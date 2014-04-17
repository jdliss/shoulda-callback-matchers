# :enddoc:
module Shoulda
  module Callback
    module Matchers
      module RailsVersionHelper
        def rails_4_1?
          rails_4? && ActiveRecord::VERSION::MINOR == 1
        end
  
        def rails_4_0?
          rails_4? && ActiveRecord::VERSION::MINOR == 0
        end
  
        def rails_4?
          ActiveRecord::VERSION::MAJOR == 4
        end
  
        def rails_3?
          ActiveRecord::VERSION::MAJOR == 3
        end
      end
    end
  end
end