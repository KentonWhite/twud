require File.dirname(__FILE__) + '/../spec_helper'

describe Account do 
  
  def new_account(attributes = {}) 
    attributes[:request_token] ||= 'token'
    attributes[:request_secret] ||= 'key'
    Account.new(attributes)
  end
  
  it "should be valid" do
    new_account.should be_valid
  end 
  
  it 'should be invalid' do
    Account.new().should_not be_valid
  end 
end

describe Account, 'authorize' do 
  
  def authorize
    VCR.use_cassette('oauth_request_token', :record => :new_episodes) do
      @account = Account.new
      @url = @account.authorize('www.example.com/accounts/create') 
    end    
  end
  
  it 'should generate the authorization URL' do 
    authorize
    request_token = 'y34FUj5owAF7PYR4pAUjUa81FZxHCRbFSyx0Cjbu0E'
    @url.should == "https://api.twitter.com/oauth/authenticate?force_login=true&oauth_token=#{request_token}"
  end
  
  it 'should add a request_token' do
    authorize
    request_token = 'y34FUj5owAF7PYR4pAUjUa81FZxHCRbFSyx0Cjbu0E'    
    @account.request_token.should == request_token
  end

  it 'should add a request_secret' do
    authorize
    request_secret = 'P6rBc8TbKUjdsu8Pv1rgAzteaLvQg1SRcj1PisA2Jc'    
    @account.request_secret.should == request_secret
  end
  
  it 'should save a temporary account' do
    proc {
      authorize
    }.should change(Account, :count).by(1)
  end  
end
