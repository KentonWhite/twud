# config/initializers/twitter_stream.rb

module Jobs
  module ScheduledJob
    def self.included(base)
      base.extend(ClassMethods)
    end
  	  
    def perform_with_schedule
      Delayed::Job.enqueue self, 0, self.class.schedule.from_now.getutc
      perform_without_schedule
    end

    module ClassMethods
      def method_added(name)
        if name.to_s == "perform" && !@redefined
          @redefined = true
          alias_method_chain :perform, :schedule
        end
      end
  	    
      def schedule
        @schedule
      end
  	    
      def run_every(time)
        @schedule = time
      end  
    end

  end
end

puts "Starting TwitterSteam worker" 

Delayed::Job.enqueue TwitterStream.new(1.hour) unless Delayed::Job.find(:all).size > 0
