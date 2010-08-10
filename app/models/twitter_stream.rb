class TwitterStream 
  require 'tweetstream'
  include Jobs::ScheduledJob
  
  def initialize(time)
    self.class.run_every(time)
  end

  def perform
    # This will pull a sample of all tweets based on
    # your Twitter account's Streaming API role.
    TweetStream::Client.new('twudnet','mopa3lwb').sample do |status|
      # The status object is a special Hash with
      # method access to its keys.
      puts "#{status.text}"
    end
  end
end
