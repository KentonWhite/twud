# config/initializers/twitter.rb

module Twitter
  CONFIG = YAML.load(ERB.new(File.read("#{Rails.root}/config/twitter.yml")).result)[Rails.env]
  CONSUMER_KEY = CONFIG['consumer_key']
  CONSUMER_SECRET = CONFIG['consumer_secret']  
end
