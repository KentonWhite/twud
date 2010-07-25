class ApplicationController < ActionController::Base
  include Authentication
  protect_from_forgery
  layout 'application' 
  # before_filter :login_required
end
