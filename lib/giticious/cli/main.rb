module Giticious
  module Cli
    class Main < Thor
      package_name 'Giticious'

      desc "version", "Prints versioning information"
      def version
        puts "Giticious: #{Giticious::VERSION}"
        puts "Ruby: #{RUBY_VERSION}"
      end

      desc "check", "Checks if the Giticious installation is healthy"
      def check
        begin
          Giticious::Check.run
          puts "Everything looks fine!"
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

      desc "init", "Initializes the Git server"
      def init
        begin
          Giticious::Setup.run
        rescue => e
          $stderr.puts e.message
          exit 1
        end
      end

      desc "gitserve", "Hidden task to serve git ssh requests", hide: true
      def gitserve(user)
        abort unless user
        abort if ENV["SSH_ORIGINAL_COMMAND"].nil?

        command_match = ENV["SSH_ORIGINAL_COMMAND"].match(/(git\-upload\-pack|git\-receive\-pack) \'([A-Za-z0-9\-_\.]+)\.git\'/)
        abort "Project not found / Command invalid" if command_match.nil?

        action = command_match[1]
        repo = command_match[2]
        perms = Giticious::Service::Repository.new.permissions_for(repo, user)        
        abort "You have no access to #{repo}" if perms == false

        command = "#{command_match[1]} 'repositories/#{command_match[2]}.git'"

        abort "Read access denied" unless perms.perm_read

        if action == "git-receive-pack"
          abort "Write access denied" unless perms.perm_write
        end

        Kernel.exec "git", "shell", "-c", command
      end

      register(Giticious::Cli::Repo, "repo", "repo COMMAND", "Manage repositories")
      register(Giticious::Cli::User, "user", "user COMMAND", "Manage users")
      register(Giticious::Cli::Pubkey, "pubkey", "pubkey COMMAND", "Manage pubkeys")

    end
  end
end