describe "routing to create account" do
  it "routes /accounts/create to accounts#create" do
    { :get => "/accounts/create" }.should route_to(
      :controller => "accounts",
      :action => "create"
    )
  end
end
