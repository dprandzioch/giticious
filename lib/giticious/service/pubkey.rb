module Giticious
  module Service
    class Pubkey

      def initialize
          @filename = "#{Dir.home}/.ssh/authorized_keys"

          if false == File.exists?(@filename)
            FileUtils.touch(@filename)
          end

          if false == File.owned?(@filename)
            raise RuntimeError, "File #{@filename} is not owned by the current user"
          end
      end

      def exists?(pubkey)
        File.open(@filename) do |file|
          file.each_line do |line|
            return true if line.include?(pubkey)
          end
        end

        false
      end

      def add(user, pubkey)
        if exists?(pubkey)
          raise RuntimeError, "This public key does already exist"
        end

        append_line('command="/usr/local/bin/giticious gitserve ' + user + '",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty ' + pubkey)
      end

      def delete(pubkey)
        delete_matches(pubkey)
      end

      def all
        matches = {}

        File.open(@filename) do |file|
          file.each_line do |line|
            res = line.match(/gitserve ([A-Za-z0-9_]+)\".*no\-pty (.*)/)

            if res.nil? == false
              username = res[1]
              key = res[2]

              if matches.has_key?(username) == false
                matches[username] = []
              end

              matches[username] << key
            end
          end
        end

        matches
      end

      def user_pubkeys(user)
        pubkeys = all()

        if pubkeys.has_key?(user)
          return pubkeys[user]
        end

        return []
      end

      protected
        def file_contents
          File.read(@filename)
        end

        def append_line(line)
          IO.write(@filename, "#{line}\n", mode: "a")
        end

        def delete_matches(search)
          if search == ""
            return nil
          end

          new_file = ""

          File.open(@filename) do |file|
            file.each_line do |line|
              new_file += "#{line}" unless line.include?(search)
            end
          end

          IO.write(@filename, new_file, mode: "w+")
        end

    end
  end
end