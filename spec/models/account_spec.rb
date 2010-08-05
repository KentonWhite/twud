require File.dirname(__FILE__) + '/../spec_helper'

describe Account do 
  
  def new_account(attributes = {}) 
    attributes[:name] ||= 'twudnet'
    attributes[:token] ||= 'token'
    attributes[:key] ||= 'key'
    Account.new(attributes)
  end
  
  it "should be valid" do
    new_account.should be_valid
  end 
  
  it 'should be invalid' do
    Account.new().should_not be_valid
  end
end
