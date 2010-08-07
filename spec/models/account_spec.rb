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
  
  it 'should generate the authorization URL' do 
    token = 'y34FUj5owAF7PYR4pAUjUa81FZxHCRbFSyx0Cjbu0E'
    VCR.use_cassette('post', :record => :new_episodes) do
      @url = Account.new().authorize_url('www.example.com/accounts/create')
    end  
    @url.should == "api.twitter.com/oauth/authenticate?force_login=true&oauth_token=#{token}"
  end
end
