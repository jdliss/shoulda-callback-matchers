Matchers to test before, after and around hooks(currently supports :symbol and object callbacks):
    
Symbol Callbacks:

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
      def before_save{}
      def after_create{}
      def before_validation{}
      def after_find{}
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

Be aware that this tests for the method call and not the method itself. It makes testing via triggering the callback events (validation, save) unnecessary, but you should still test the called procedure seperately.

In Rails 3 and Bundler, add the following to your Gemfile:

    group :test do
      gem "shoulda-callback-matchers"
    end

    # rspec-rails needs to be in the development group so that Rails generators
    # work.
    group :development, :test do
      gem "rspec-rails"
    end

Shoulda will automatically include matchers into the appropriate example groups.

## Credits

This gem is maintained by me,
Shoulda is maintained and funded by [thoughtbot](http://thoughtbot.com/community)

## License

Shoulda is Copyright © 2006-2012 thoughtbot, inc.
Callback Matchers is Copyright © 2012 Beat Richartz
It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
