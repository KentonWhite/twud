require File.dirname(__FILE__) + '/../spec_helper'
 
describe AdminsController do
  fixtures :users
  render_views
  
  it "show action should render show template" do
    login "foo"
    get :show
    response.should render_template(:show)
  end
end
