class Player < ActiveRecord::Base  
  validates_presence_of :name
  validates_format_of :name, :with => /^[A-Za-z0-9_]+$/
  validates_uniqueness_of :name
end