Matchers to test before, after and around hooks:
    
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
    
Be aware that this tests for the method call and not the method itself. It makes testing via triggering the callback events (validation, save) unnecessary, but you should still test the called procedure seperately.

In Rails 4 and Bundler, add the following to your Gemfile:

    group :test do
      gem "shoulda-callback-matchers", ">=0.0.3"
    end


In Rails 3 and Bundler, add version 0.0.2 to your Gemfile:

    group :test do
      gem "shoulda-callback-matchers", "=0.0.2"
    end

rspec-rails needs to be in the development group so that Rails generators work.

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
