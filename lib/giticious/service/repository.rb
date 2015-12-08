module Giticious
  module Service
    class Repository

      def list
        Giticious::Model::Repository.all
      end

      def create(name)
        path = "#{Dir.home}/repositories/#{name}.git"

        if init_repository(path) == false
          raise RuntimeError, "Could not initi Git repository"
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
        FileUtils.rm_rf("#{Dir.home}/repositories/#{repo.name}.git")

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