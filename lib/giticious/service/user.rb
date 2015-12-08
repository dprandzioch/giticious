module Giticious
  module Service
    class User

      def list
        users = []

        Giticious::Model::User.all.each do |user|
          users << {
            id: user.id,
            username: user.username,
          }
        end

        users
      end

      def create(username)
        if Giticious::Model::User.find_by_username(username).nil? == false
          raise ArgumentError, "a user with this name does already exist"
        end

        user = Giticious::Model::User.new
        user.username = username

        user.save!
      end

      def delete_by_username(username)
        user = Giticious::Model::User.find_by_user(username).first!

        Giticious::Model::Permission.find_by_user_id(user.id).delete_all!

        user.destroy!
      end

      def exists?(username)
        Giticious::Model::User.find_by_username(username).nil? == false
      end

    end
  end
end