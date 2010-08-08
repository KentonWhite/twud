require File.dirname(__FILE__) + '/../spec_helper'
  def new_account(attributes = {}) 
    attributes[:request_token] ||= 'token'
    attributes[:request_secret] ||= 'key'
    Account.new(attributes)
  end

describe Account do 
  
  
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
  
describe Account, 'clear_stale_request_tokens' do 
  
  before(:each) do
    Account.delete_all
  end
  it 'should remove the stale, unauthorized request token' do
    account = new_account
    account.save
    Account.any_instance.stubs(:created_at).returns(1.hour.ago) 
    proc {
      Account.remove_stale_requests
    }.should change(Account, :count).by(-1)
  end
  
  it 'should keep the authorized token' do
    account = new_account()  
    account.authorized = true
    account.save
    Account.any_instance.stubs(:created_at).returns(1.hour.ago) 
    proc {
      Account.remove_stale_requests
    }.should_not change(Account, :count)
  end                                          
  
  it 'should keep the pending request token' do
    account = new_account
    account.save
    Account.any_instance.stubs(:created_at).returns(1.minute.ago) 
    proc {
      Account.remove_stale_requests
    }.should_not change(Account, :count)
  end
end

describe Account, 'exchange_token' do 
  fixtures :accounts 
  
  def exchange_token
    request_token = '3rNTkmqrgSxyOzGpvSuqMkkTemRdIn3E2sbuE7TjI4'
    @account = Account.find_by_request_token(request_token)
    VCR.use_cassette('oauth_exchange_token', :record => :new_episodes) do
      @account.exchange_token('R5lGrk41CuQB9JKx9jfGTg0l2iADIQNRdEKZeaMRyG0')
    end   
  end
  
  before(:each) do
    exchange_token
  end 
  
  it 'should return account with request_token' do
    request_token = '3rNTkmqrgSxyOzGpvSuqMkkTemRdIn3E2sbuE7TjI4'
    @account.request_token.should == request_token
  end
  
  it 'should save account' do
    Account.any_instance.expects(:save)
    exchange_token
  end
  
  it 'should set access_token' do
    access_token = '172935359-IeYANm4s7GQ6mTl9hXYZya3q45gKVxjbIXF9Wkko'
    @account.access_token.should == access_token
  end                                 
                    
  it 'should set access_secret' do
    access_secret = 'R5PCZlL4rbLVZBUiIdIQ5LX6hvK55KAw1t2jchA78aQ'
    @account.access_secret.should == access_secret    
  end                                  
  
  it 'should set name' do
    name = 'twudnet'
    Account.any_instance.stubs(:get_screen_name).returns(name) 
    exchange_token
    @account.name.should == name    
  end                         
  
  it 'should set as authorized' do
    @account.authorized.should be_true    
  end
end   

describe Account, 'get_screen_name' do
  fixtures :accounts
  it 'should return screen name' do
    account = accounts(:two)
    VCR.use_cassette('get_screen_name', :record => :new_episodes) do
      account.send(:get_screen_name).should == account.name
    end
  end
end

describe Account, 'open_twitter' do
  fixtures :accounts
  it 'should open twitter account' do
    account = accounts(:two)
    account.send(:open_twitter).should_not be_nil
  end
end