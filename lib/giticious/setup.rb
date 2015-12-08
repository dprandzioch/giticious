module Giticious
  class Setup

    def self.run
      self.create_config_dir
      self.create_repo_dir
      self.migrate_db
    end

    protected
      def self.migrate_db
        ActiveRecord::Schema.define do
          create_table :repositories do |table|
            table.column :name, :string, :unique => true
            table.column :path, :string
          end

          create_table :users do |table|
            table.column :username, :string, :unique => true
          end

          create_table :permissions do |table|
            table.column :user_id, :integer
            table.column :repository_id, :integer
            table.column :perm_read, :boolean
            table.column :perm_write, :boolean
          end
        end
      end

      def self.create_config_dir
        config_dir = "#{Dir.home}/.giticious"

        FileUtils.mkdir(config_dir) unless Dir.exists?(config_dir)
      end

      def self.create_repo_dir
        repo_dir = "#{Dir.home}/repositories"

        FileUtils.mkdir(repo_dir) unless Dir.exists?(repo_dir)
      end

  end
end