module Estimate
  module IssuePatch
    def self.included(base)
      base.send(:include, InstanceMethods)
      base.class_eval do
        unloadable # Send unloadable so it will not be unloaded in development
        before_save :update_estimated_hours
      end
    end
    
    module InstanceMethods
      # Updates the estimate after checking if it is already in range of the effort category
      def update_estimated_hours
        set_estimate_from_effort
      end

      # Set the estimate from the effort category
      def set_estimate_from_effort
        estimated_effort = self.story_points #custom_value.value
        unless estimated_effort.blank?
        self.estimated_hours = case estimated_effort.to_i
           when 1 then 4
           when 2 then 8
           when 3 then 12
           when 5 then 20
           when 8 then 32
         end
       end
      end  

    end    
  end
end
