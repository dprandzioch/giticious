module Giticious
  module Service
    class Repository

      def list
        Giticious::Model::Repository.all
      end

      def build_repo_path(name)
        if name.empty?
          raise ArgumentError, "repo name may not be empty"
        end

        "#{Dir.home}/repositories/#{name}.git"
      end

      def build_temp_path(name)
        "#{Dir.home}/.giticious/temp_#{File.basename(name)}"
      end

      def import(url)
        target_repo_name = File.basename(url).gsub(".git", "")
        
        if create(target_repo_name) == false
          raise RuntimeError, "Could not create repository"
        end

        temp_name = build_temp_path(url)  

        begin
          new_url = build_repo_path(target_repo_name)

          `git clone #{url} #{temp_name}`

          if $?.success? == false
            raise RuntimeError, "Could not clone repo URL"
          end

          `cd #{temp_name} && git remote add new #{new_url} && git push --all new`

          if $?.success? == false
            raise RuntimeError, "Could not import repo"
          end
        rescue => e
          delete(target_repo_name)
          raise e
        finally
          FileUtils.rm_rf(temp_name)
        end
      end

      def create(name)
        path = build_repo_path(name)

        if init_repository(path) == false
          raise RuntimeError, "Could not init Git repository"
        end

        repo = Giticious::Model::Repository.new
        repo.name = name
        repo.path = path

        repo.save!
      end

      def delete(name)
        repo = Giticious::Model::Repository.find_by_name(name)

        if repo.nil?
          raise ArgumentError, "The selected repository does not exist"
        end

        Giticious::Model::Permission.where(repository_id: repo.id).delete_all
        FileUtils.rm_rf(build_repo_path(repo.name))

        repo.delete
      end

      def permissions(repo)
        repo = Giticious::Model::Repository.find_by_name(repo)

        if repo.nil?
          raise ArgumentError, "The selected repository does not exist"
        end

        repo.permissions
      end

      def permissions_for(repo_name, username)
        repo = Giticious::Model::Repository.find_by_name(repo_name)

        if repo.nil?
          raise ArgumentError, "The selected repository does not exist"
        end

        user = Giticious::Model::User.find_by_username(username)

        if user.nil?
          raise ArgumentError, "The selected user does not exist"
        end

        permissions = Giticious::Model::Permission.where(user_id: user.id, repository_id: repo.id)

        if permissions.empty?
          return false
        end

        return permissions.first!
      end

      def delete_user(repo_name, username)
        repo = Giticious::Model::Repository.find_by_name(repo_name)

        if repo.nil?
          raise ArgumentError, "The selected repository does not exist"
        end

        user = Giticious::Model::User.find_by_username(username)

        if user.nil?
          raise ArgumentError, "The selected user does not exist"
        end

        perms = Giticious::Model::Permission.where(user_id: user.id, repository_id: repo.id)

        if perms.empty?
          raise ArgumentError, "This user does not have permissions"
        end

        perms.delete_all
      end

      def add_user(repo_name, username, permissions)
        repo = Giticious::Model::Repository.find_by_name(repo_name)

        if repo.nil?
          raise ArgumentError, "The selected repository does not exist"
        end

        user = Giticious::Model::User.find_by_username(username)

        if user.nil?
          raise ArgumentError, "The selected user does not exist"
        end

        if Giticious::Model::Permission.where(user_id: user.id, repository_id: repo.id).empty? == false
          raise ArgumentError, "This user does already have permissions"
        end

        perm = Giticious::Model::Permission.new
        perm.repository_id = repo.id
        perm.user_id = user.id
        perm.perm_read = permissions.include?("r")
        perm.perm_write = permissions.include?("w")

        perm.save!
      end

      protected
        def init_repository(path)
          if Dir.exists?(path)
            raise ArgumentError, "repo path #{path} does already exist"
          end

          `git init --bare #{path}` and $?.success?
        end

    end
  end
end