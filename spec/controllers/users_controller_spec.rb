require File.dirname(__FILE__) + '/../spec_helper'
 
describe UsersController do
  fixtures :all
  render_views 
    
  it "new action without login should redirect to login" do
    get :new
    response.should redirect_to(login_url)
  end
  
  it "new action should render new template" do
    login "foo"
    get :new
    response.should render_template(:new)
  end
  
  it "create action should render new template when model is invalid" do
    login "foo"
    User.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end
  
  it "create action should redirect when model is valid" do
    login "foo"
    User.any_instance.stubs(:valid?).returns(true)
    post :create
    response.should redirect_to("/")
    session['user_id'].should == assigns['user'].id
  end
end
