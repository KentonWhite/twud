class Account < ActiveRecord::Base
  attr_accessible :name, :request_token, :request_secret, :access_token, :access_secret
  attr_protected :authorized, :access_token, :access_secret
  
  validates_presence_of :request_token, :request_secret

  def authorize(redirect_url)
    oauth = Twitter::OAuth.new(Twitter::CONSUMER_KEY, Twitter::CONSUMER_SECRET, :sign_in => true)
    request_token = oauth.request_token :oauth_callback => redirect_url
    self.request_token = request_token.token
    self.request_secret = request_token.secret
    self.save     
    "https://#{request_token.authorize_url(:force_login => 'true')}"
  end 
  
  def exchange_token(verifier)
    oauth = create_oauth_session 
    oauth.authorize_from_request(
      self.request_token, self.request_secret, verifier
    ) 
    @twitter = Twitter::Base.new(oauth)
    self.access_token = twitter.client.access_token.token 
    self.access_secret = twitter.client.access_token.secret 
    self.name = self.get_screen_name
    self.authorized = true
    self.save 
    self
  end
  
  def authorized?
    self.authorized
  end
  
  def self.remove_stale_requests
    Account.all.each do |a|  
      a.destroy unless (a.authorized? || a.created_at > 10.minutes.ago)
    end
  end 
  
  protected  
  
  def create_oauth_session
    Twitter::OAuth.new(Twitter::CONSUMER_KEY, Twitter::CONSUMER_SECRET)
  end 
  
  def twitter
    @twitter ||= open_twitter
  end 
  
  def get_screen_name
    twitter.verify_credentials.screen_name
  end 
  
  def open_twitter
     oauth = create_oauth_session
     oauth.authorize_from_access(self.access_token, self.access_secret)
     Twitter::Base.new(oauth)
  end  

end
