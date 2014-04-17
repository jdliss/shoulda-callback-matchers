#Shoulda Callback Matchers
[![Gem Version](https://badge.fury.io/rb/shoulda-callback-matchers.svg)](http://badge.fury.io/rb/shoulda-callback-matchers) [![Build Status](https://travis-ci.org/beatrichartz/shoulda-callback-matchers.svg?branch=master)](https://travis-ci.org/beatrichartz/shoulda-callback-matchers) [![Code Climate](https://codeclimate.com/github/beatrichartz/shoulda-callback-matchers.png)](https://codeclimate.com/github/beatrichartz/shoulda-callback-matchers) [![Dependency Status](https://gemnasium.com/beatrichartz/shoulda-callback-matchers.svg)](https://gemnasium.com/beatrichartz/shoulda-callback-matchers)


Matchers to test before, after and around hooks(currently supports method and object callbacks):

## Usage

Method Callbacks:

    describe Post do
      it { should callback(:count_comments).before(:save) }
      it { should callback(:post_to_twitter).after(:create) }
      it { should callback(:evaluate_if_should_validate).before(:validation) }
      it { should callback(:add_some_convenience_accessors).after(:find) }
    end
    
    describe User do
      it { should_not callback(:make_email_validation_ready!).before(:validation).on(:update) }
      it { should callback(:make_email_validation_ready!).before(:validation).on(:create) }
      it { should callback(:update_user_count).before(:destroy) }
    end

Object Callbacks:

    class CallbackClass
      def before_save
				...
			end
			
      def after_create
				...
			end
			
      def before_validation
				...
			end
			
      def after_find
				...
			end
    end
    
    describe Post do
      it { should callback(CallbackClass).before(:save) }
      it { should callback(CallbackClass).after(:create) }
      it { should callback(CallbackClass).before(:validation) }
      it { should callback(CallbackClass).after(:find) }
    end
    
    describe User do
      it { should_not callback(CallbackClass).before(:validation).on(:update) }
      it { should callback(CallbackClass).before(:validation).on(:create) }
      it { should callback(CallbackClass).before(:destroy) }
    end

This will test:
- the method call
- method existence

Either on the model itself or on the callback object. Be aware that obviously this does not test the callback method or object itself. It makes testing via triggering the callback events (validation, save) unnecessary, but you still have to test the called procedure seperately.

In Rails 3 or 4 and Bundler, add the following to your Gemfile:

    group :test do
      gem "shoulda-callback-matchers", "~> 1.0"
    end

This gem uses semantic versioning, so you won't have incompability issues with patches.

rspec-rails needs to be in the development group so that Rails generators work.

    group :development, :test do
      gem "rspec-rails"
    end

Shoulda will automatically include matchers into the appropriate example groups.

## Credits

This gem is maintained by me and its contributors,
Shoulda is maintained and funded by [thoughtbot](http://thoughtbot.com/community)

## Contributors & Contributions
- @pvertenten (callback objects)

Let's make this gem useful, send me a PR if you've discovered an issue you'd like to fix!

## License

Shoulda is Copyright © 2006-2014 thoughtbot, inc.
Callback Matchers is Copyright © 2014 Beat Richartz
It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
