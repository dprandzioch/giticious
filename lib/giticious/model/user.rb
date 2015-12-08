module Giticious
  module Model
    class User < ActiveRecord::Base
      has_many :permissions
    end
  end
end