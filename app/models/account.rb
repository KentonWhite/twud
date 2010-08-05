class Account < ActiveRecord::Base
  attr_accessible :name, :token, :key 
  
  validates_presence_of :name, :token, :key
end
