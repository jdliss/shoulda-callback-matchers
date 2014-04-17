TESTAPP_ROOT = Pathname.new File.expand_path('../tmp/aruba/testapp', __FILE__)
FileUtils.rm_rf TESTAPP_ROOT if File.exists? TESTAPP_ROOT

ENV['RAILS_ENV'] = 'test'
ENV['BUNDLE_GEMFILE'] ||= TESTAPP_ROOT.join('Gemfile')

`rails new #{TESTAPP_ROOT}`

require TESTAPP_ROOT.join('config', 'environment')
require 'shoulda-callback-matchers'
require 'rspec/rails'

PROJECT_ROOT = Pathname.new File.expand_path('../..', __FILE__)
$LOAD_PATH << PROJECT_ROOT.join('lib')

Dir[PROJECT_ROOT.join('spec', 'support', '**', '*.rb')].each do |file|
  require file
end

# Run the migrations
ActiveRecord::Migration.verbose = false
ActiveRecord::Migrator.migrate("#{Rails.root}/db/migrate")


RSpec.configure do |config|
  config.include ClassBuilder
  config.include ModelBuilder
end