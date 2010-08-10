class TwitterStream 
  
  include Jobs::ScheduledJob
  
  def initialize(time)
    self.class.run_every(time)
  end

  def perform
    puts "performing!!!"
  end
end
