# :enddoc:
module Shoulda
  module Callback
    module Matchers
      module RailsVersionHelper
        def rails_4_1?
          rails_4? && minor_version_equals?(1)
        end
  
        def rails_4_0?
          rails_4? && minor_version_equals?(0)
        end
  
        def rails_4?
          major_version_equals? 4
        end
  
        def rails_3?
          major_version_equals? 3
        end
        
        private
        
        def major_version_equals? number
          if active_record?
            ::ActiveRecord::VERSION::MAJOR == number
          else
            ::ActiveModel::VERSION::MAJOR == number
          end
        end
        
        def minor_version_equals? number
          if active_record?
            ::ActiveRecord::VERSION::MINOR == number
          else
            ::ActiveModel::VERSION::MINOR == number
          end
        end
        
        def active_record?
          defined?(::ActiveRecord)
        end
      end
    end
  end
end
