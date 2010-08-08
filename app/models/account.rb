class Account < ActiveRecord::Base
  attr_accessible :name, :request_token, :request_secret, :access_token, :access_secret
  
  validates_presence_of :request_token, :request_secret

  def authorize(redirect_url)
    oauth = Twitter::OAuth.new(Twitter::CONSUMER_KEY, Twitter::CONSUMER_SECRET, :sign_in => true)
    request_token = oauth.request_token :oauth_callback => redirect_url
    self.request_token = request_token.token
    self.request_secret = request_token.secret
    self.save     
    "https://#{request_token.authorize_url(:force_login => 'true')}"
  end  
  
  protected
  
end
