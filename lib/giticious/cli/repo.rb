module Giticious
  module Cli
    class Repo < Thor
      
      desc "create NAME", "Create a new repository"
      def create(name)
        begin
          Giticious::Service::Repository.new.create(name)
          puts "The repository has been created"
          list()
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

      desc "import URL", "Create a repository and import the repository at this URL"
      def import(url)
        begin
          puts "Importing #{url}..."
          Giticious::Service::Repository.new.import(url)
          puts "Repository imported"
          list()
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

      desc "delete", "Removes a repository"
      def delete(name)
        begin
          Giticious::Service::Repository.new.delete(name)
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

      desc "list", "List all repositories"
      def list
        begin
          rows = []

          Giticious::Service::Repository.new.list.each do |repo|
            rows << [ repo.name, repo.path, "#{Etc.getlogin}@<your-server-url>:#{repo.name}.git" ]
          end

          table = Terminal::Table.new :headings => ["Name", "Path", "SSH URL"], :rows => rows
          puts table
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

      desc "users REPO", "List all users with access to a repository"
      def users(repo)
        begin
          rows = []

          Giticious::Service::Repository.new.permissions(repo).each do |perm|
            rows << [ repo, perm.user.username, perm.perm_read, perm.perm_write ]
          end

          table = Terminal::Table.new :headings => ["Repository", "User", "Read", "Write"], :rows => rows
          puts table
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

      desc "permit REPO USERNAME ACCESS", "Gives a user permissions to access a repository (access: r,w,rw)"
      def permit(repo, username, permissions)
        begin
          if Giticious::Service::Repository.new.add_user(repo, username, permissions) == false
            $stderr.puts "Could not grant permissions to this user"
            exit 1
          end

          puts "Permission granted!"

          users(repo)
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

      desc "revoke REPO USERNAME", "Revokes user it's permissions to the repository"
      def revoke(repo, username)
        begin
          if Giticious::Service::Repository.new.delete_user(repo, username) == false
            $stderr.puts "Could not revoke permissions from this user"
            exit 1
          end

          puts "Permission revoked!"

          users(repo)
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

    end
  end
end