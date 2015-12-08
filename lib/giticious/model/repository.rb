module Giticious
  module Model
    class Repository < ActiveRecord::Base
      has_many :permissions
    end
  end
end