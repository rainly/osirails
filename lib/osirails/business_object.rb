module Osirails
  class BusinessObject < ActiveRecord::Base
    require Osirails::Permisible
    
    def BusinessObject.can_list?(roles = {})
      Permission.can_list?(self.class, roles)
    end
  end
  
  class Document < BusinessObject
    def bonbon
        #
    end
  end
end
puts "Pffffff"