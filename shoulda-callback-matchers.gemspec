$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'shoulda/callback/matchers/version'

Gem::Specification.new do |s|
  s.name        = "shoulda-callback-matchers"
  s.version     = Shoulda::Callback::Matchers::VERSION.dup
  s.authors     = ["Beat Richartz"]
  s.date        = Time.now.strftime("%Y-%m-%d")
  s.email       = "attraccessor@gmail.com"
  s.homepage    = "http://github.com/beatrichartz/shoulda-callback-matchers"
  s.summary     = "Making callback tests easy on the fingers and eyes"
  s.description = "Making callback tests easy on the fingers and eyes"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('activesupport', '>= 3.0.0')

  s.add_development_dependency('appraisal',   '~> 0.5.0')
  s.add_development_dependency('aruba')
  s.add_development_dependency('bourne',      '~> 1.3.0')
  s.add_development_dependency('bundler',     '>= 1.1.0')
  s.add_development_dependency('rails',       '>= 3.0')
  s.add_development_dependency('rake',        '~> 10.0.0')
  s.add_development_dependency('rspec-rails', '~> 2.12.0')
end
