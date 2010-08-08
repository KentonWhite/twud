require File.dirname(__FILE__) + '/../spec_helper'
 
describe AccountsController do
  fixtures :accounts
  render_views 
  
  before(:each) do
    login 'foo'
  end
  
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
  
  it "show action should render show template" do
    get :show, :id => accounts(:one)
    response.should render_template(:show)
  end 
    
  it "new action should redirect to authentication" do
    url = 'www.example.com/oauth/authenticate'
    Account.any_instance.expects(:authorize).with(accounts_url(:method => :post)).returns(url)
    get :new
    response.should redirect_to(url)
  end
  
  it "create action should redirect to new when model is invalid" do
    Account.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should redirect_to(new_account_url)
  end
  
  it "create action should redirect when model is valid" do
    Account.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to(account_url(assigns[:account]))
  end
    
  it "destroy action should destroy model and redirect to index action" do
    account = Account.first
    delete :destroy, :id => account
    response.should redirect_to(accounts_url)
    Account.exists?(account.id).should be_false
  end
end
