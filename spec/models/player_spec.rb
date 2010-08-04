require 'spec_helper'

describe Player do
  def new_player(attributes = {})
    attributes[:name] ||= 'twud_test'
    Player.new(attributes)
  end
  
  before(:each) do
    Player.delete_all
  end
  
  it "should be valid" do
    new_player.should be_valid
  end
  
  it 'should not be valid' do
    new_player(:name => 'twud test').should_not be_valid
  end
  
  it 'should require a name' do
    Player.new().should_not be_valid
  end
  
  it "should validate uniqueness of name" do
    new_player(:name => 'uniquename').save!
    new_player(:name => 'uniquename').should have(1).error_on(:name)
  end
  
end