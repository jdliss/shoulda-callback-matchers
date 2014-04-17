require 'shoulda/callback/matchers/version'
require 'shoulda/callback/matchers/rails_version_helper'

if defined?(RSpec)
  require 'shoulda/callback/matchers/integrations/rspec'
end

require 'shoulda/callback/matchers/integrations/test_unit'
