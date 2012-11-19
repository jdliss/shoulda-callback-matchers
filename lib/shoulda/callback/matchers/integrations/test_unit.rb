# :enddoc:

# in environments where test/unit is not required, this is necessary
unless defined?(Test::Unit::TestCase)
  begin
    require 'test/unit' 
  rescue LoadError
    # silent
  end
end

if defined?(ActiveRecord)
  require 'shoulda/callback/matchers/active_model'

  module Test
    module Unit
      class TestCase
        include Shoulda::Callback::Matchers::ActiveModel        
        extend Shoulda::Callback::Matchers::ActiveModel
      end
    end
  end
elsif defined?(ActiveModel)
  require 'shoulda/callback/matchers/active_model'
  
  module Test
    module Unit
      class TestCase
        include Shoulda::Callback::Matchers::ActiveModel
        extend Shoulda::Callback::Matchers::ActiveModel
      end
    end
  end
end
