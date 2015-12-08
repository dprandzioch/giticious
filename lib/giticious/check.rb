require 'socket'
require 'timeout'

module Giticious
  class Check

    def self.run
      if self.git_installed? == false
        raise RuntimeError, "Git is not installed"
      end

      if self.repository_dir_exists? == false
        raise RuntimeError, "Repository dir not found! Please run the init command"
      end

      if self.ssh_alive? == false
        raise RuntimeError, "SSH service not listening on Port 22! Please enable it and use public key auth"
      end
    end

    protected
      def self.git_installed?
        `which git 2>/dev/null` and $?.success?
      end

      def self.repository_dir_exists?
        Dir.exists?("#{Dir.home}/repositories")
      end

      def self.ssh_alive?
        begin
          Timeout::timeout(5) do
            begin
              s = TCPSocket.new("127.0.0.1", 22)
              s.close
              return true
            rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
              return false
            end
          end
        rescue Timeout::Error
        end

        false
      end
  end
end