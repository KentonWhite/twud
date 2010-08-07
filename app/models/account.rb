class Account < ActiveRecord::Base
  attr_accessible :name, :token, :key 
  
  validates_presence_of :name, :token, :key
  
  def authorize_url(redirect_url)
    oauth = Twitter::OAuth.new(Twitter::CONSUMER_KEY, Twitter::CONSUMER_SECRET, :sign_in => true)
    request_token =  oauth.request_token :oauth_callback => redirect_url
    # session[:request_token] = request_token.token
    # session[:request_secret] = request_token.secret
    request_token.authorize_url :force_login => 'true'     
  end
end
