require 'terminal-table'
require 'open3'
require 'resolv'
require 'logger'
require 'fileutils'
require 'sqlite3'
require 'active_record'
require 'etc'

#ActiveRecord::Base.logger = Logger.new(STDERR)

ActiveRecord::Base.establish_connection(
  :adapter  => "sqlite3",
  :database => "#{Dir.home}/.giticious/database.sqlite"
)

require File.join(File.dirname(__FILE__), 'giticious/version')

require File.join(File.dirname(__FILE__), 'giticious/model/user')
require File.join(File.dirname(__FILE__), 'giticious/model/repository')
require File.join(File.dirname(__FILE__), 'giticious/model/permission')

require File.join(File.dirname(__FILE__), 'giticious/service/pubkey')
require File.join(File.dirname(__FILE__), 'giticious/service/user')
require File.join(File.dirname(__FILE__), 'giticious/service/repository')

require File.join(File.dirname(__FILE__), 'giticious/check')
require File.join(File.dirname(__FILE__), 'giticious/setup')

module Giticious
  LIBNAME = 'giticious'
  LIBDIR = File.expand_path("../#{LIBNAME}", __FILE__)

  # build params
end