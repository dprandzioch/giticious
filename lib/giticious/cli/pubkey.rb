module Giticious
  module Cli
    class Pubkey < Thor
      
      desc "add USERNAME PUBKEY", "Adds a public key to a user"
      def add(username, pubkey)
        begin
          if Giticious::Service::User.new.exists?(username) == false
            $stderr.puts "A user with this name does not exist"
            exit 1
          end

          giticious_path = File.realpath(File.join(Giticious::LIBDIR, "..", "..", "bin", "giticious"))

          if Giticious::Service::Pubkey.new.add(username, pubkey, giticious_path)
            puts "Public key \"#{pubkey.split(//).last(80).join}\" for user #{username} has been added!"
          end

          list(username)
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

      desc "delete PUBKEY", "Removes a public key from user (a part of the key is enough, but make it unique)"
      def delete(pubkey)
        begin
          Giticious::Service::Pubkey.new.delete(pubkey)
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

      desc "list USERNAME", "List registered public keys for user"
      def list(username)
        begin
          rows = []

          Giticious::Service::Pubkey.new.user_pubkeys(username).each do |pubkey|
            rows << [ username, pubkey.split(//).last(80).join ]
          end


          table = Terminal::Table.new :headings => ["Username", "Public key (last 80 chars)"], :rows => rows
          puts table
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

    end
  end
end