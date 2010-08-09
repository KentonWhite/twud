module Delayed
  module ScheduledJob

	  def self.included(base)
	    base.extend(ClassMethods)
	  end
	  
	  module ClassMethods
	    def method_added(name)
	      if name.to_s == "perform" && !@redefined
	        @redefined = true
	        alias_method_chain :perform, :schedule
	      end
	    end

	    def schedule
        if @from_now.respond_to?(:call)
          @from_now.call(self)
        elsif @from_now.respond_to?(:from_now)
          @from_now.from_now
        else
          nil
        end
	    end

	    def run_every(time)
	      @from_now = time
	    end
	  end
	  
    def schedule!
      Delayed::Job.enqueue self, 0, self.class.schedule if self.class.schedule
    end

	  def perform_with_schedule
	    perform_without_schedule
      self.schedule!
	  end
  end
end
