module Giticious
  module Cli
    class User < Thor
      
      desc "create USERNAME", "Creates a new user"
      def create(username)
        begin
          if Giticious::Service::User.new.create(username)
            puts "User #{username} has been created!"
          end

          list()
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

      desc "delete USERNAME", "Deletes a user"
      def delete(username)
        begin
          Giticious::Service::User.new.delete_by_username(username)
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

      desc "list", "Lists all users"
      def list
        begin
          rows = Giticious::Service::User.new.list.map { |result| result.values }

          table = Terminal::Table.new :headings => ["#", "Username"], :rows => rows
          puts table
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

    end
  end
end