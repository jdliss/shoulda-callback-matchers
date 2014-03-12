require 'spec_helper'

describe Shoulda::Callback::Matchers::ActiveModel do
  
  context "invalid use" do
    before do
      @callback_object_class = define_model(:callback) do
          define_method("before_create"){}
          define_method("after_save"){}
      end
      callback_object = @callback_object_class.new
      @model = define_model(:example, :attr  => :string,
                                      :other => :integer) do
        before_create :dance!, :if => :evaluates_to_false!
        after_save  :shake!, :unless => :evaluates_to_true!
        before_create callback_object, :if => :evaluates_to_false!
        after_save  callback_object, :unless => :evaluates_to_true!
        define_method(:shake!){}
        define_method(:dance!){}
      end.new
    end
    it "should return a meaningful failure message when used without a defined lifecycle" do
      matcher = callback(:dance!)
      matcher.matches?(@model).should be_false
      matcher.failure_message.should == "callback dance! can not be tested against an undefined lifecycle, use .before, .after or .around"
      matcher.negative_failure_message.should == "callback dance! can not be tested against an undefined lifecycle, use .before, .after or .around"
    end
    it "should return a meaningful failure message when used with an optional lifecycle without the original lifecycle being validation" do
      matcher = callback(:dance!).after(:create).on(:save)
      matcher.matches?(@model).should be_false
      matcher.failure_message.should == "The .on option is only valid for the validation lifecycle and cannot be used with create, use with .before(:validation) or .after(:validation)"
      matcher.negative_failure_message.should == "The .on option is only valid for the validation lifecycle and cannot be used with create, use with .before(:validation) or .after(:validation)"
    end
    it "should return a meaningful failure message when used without a defined lifecycle" do
      matcher = callback(@callback_object_class)
      matcher.matches?(@model).should be_false
      matcher.failure_message.should == "callback Callback can not be tested against an undefined lifecycle, use .before, .after or .around"
      matcher.negative_failure_message.should == "callback Callback can not be tested against an undefined lifecycle, use .before, .after or .around"
    end
    it "should return a meaningful failure message when used with an optional lifecycle without the original lifecycle being validation" do
      matcher = callback(@callback_object_class).after(:create).on(:save)
      matcher.matches?(@model).should be_false
      matcher.failure_message.should == "The .on option is only valid for the validation lifecycle and cannot be used with create, use with .before(:validation) or .after(:validation)"
      matcher.negative_failure_message.should == "The .on option is only valid for the validation lifecycle and cannot be used with create, use with .before(:validation) or .after(:validation)"
    end
  end
  
  [:save, :create, :update, :destroy].each do |lifecycle|
    context "on #{lifecycle}" do
      before do

        @callback_object_class = define_model(:callback) do
          define_method("before_#{lifecycle}"){}
          define_method("after_#{lifecycle}"){}
          define_method("around_#{lifecycle}"){}
        end

        callback_object = @callback_object_class.new

        @callback_object_not_found_class = define_model(:callback_not_fount) do
          define_method("before_#{lifecycle}"){}
          define_method("after_#{lifecycle}"){}
          define_method("around_#{lifecycle}"){}
        end

        @model = define_model(:example, :attr  => :string,
                                        :other => :integer) do
          send(:"before_#{lifecycle}", :dance!, :if => :evaluates_to_false!)
          send(:"after_#{lifecycle}", :shake!, :unless => :evaluates_to_true!)
          send(:"around_#{lifecycle}", :giggle!)
          send(:"before_#{lifecycle}", callback_object, :if => :evaluates_to_false!)
          send(:"after_#{lifecycle}", callback_object, :unless => :evaluates_to_true!)
          send(:"around_#{lifecycle}", callback_object)
          define_method(:shake!){}
          define_method(:dance!){}
          define_method(:giggle!){}
        end.new
      end
      context "as a simple callback test" do
        it "should find the callback before the fact" do
          @model.should callback(:dance!).before(lifecycle)
        end
        it "should find the callback after the fact" do
          @model.should callback(:shake!).after(lifecycle)
        end
        it "should find the callback around the fact" do
          @model.should callback(:giggle!).around(lifecycle)
        end
        it "should not find callbacks that are not there" do
          @model.should_not callback(:scream!).around(lifecycle)
        end
        it "should not find callback_objects around the fact" do
          @model.should_not callback(:shake!).around(lifecycle)
        end
        it "should have a meaningful description" do
          matcher = callback(:dance!).before(lifecycle)
          matcher.description.should == "callback dance! before #{lifecycle}"
        end
        it "should find the callback_object before the fact" do
          @model.should callback(@callback_object_class).before(lifecycle)
        end
        it "should find the callback_object after the fact" do
          @model.should callback(@callback_object_class).after(lifecycle)
        end
        it "should find the callback_object around the fact" do
          @model.should callback(@callback_object_class).around(lifecycle)
        end
        it "should not find callbacks that are not there" do
          @model.should_not callback(@callback_object_not_found_class).around(lifecycle)
        end
        it "should not find callback_objects around the fact" do
          @model.should_not callback(@callback_object_not_found_class).around(lifecycle)
        end
        it "should have a meaningful description" do
          matcher = callback(@callback_object_class).before(lifecycle)
          matcher.description.should == "callback Callback before #{lifecycle}"
        end
      end
      context "with conditions" do
        it "should match the if condition" do
          @model.should callback(:dance!).before(lifecycle).if(:evaluates_to_false!)
        end
        it "should match the unless condition" do
          @model.should callback(:shake!).after(lifecycle).unless(:evaluates_to_true!)
        end
        it "should not find callbacks not matching the conditions" do
          @model.should_not callback(:giggle!).around(lifecycle).unless(:evaluates_to_false!)
        end
        it "should not find callbacks that are not there entirely" do
          @model.should_not callback(:scream!).before(lifecycle).unless(:evaluates_to_false!)
        end
        it "should have a meaningful description" do
          matcher = callback(:dance!).after(lifecycle).unless(:evaluates_to_false!)
          matcher.description.should == "callback dance! after #{lifecycle} unless evaluates_to_false! evaluates to false"
        end

        it "should match the if condition" do
          @model.should callback(@callback_object_class).before(lifecycle).if(:evaluates_to_false!)
        end
        it "should match the unless condition" do
          @model.should callback(@callback_object_class).after(lifecycle).unless(:evaluates_to_true!)
        end
        it "should not find callbacks not matching the conditions" do
          @model.should_not callback(@callback_object_class).around(lifecycle).unless(:evaluates_to_false!)
        end
        it "should not find callbacks that are not there entirely" do
          @model.should_not callback(@callback_object_not_found_class).before(lifecycle).unless(:evaluates_to_false!)
        end
        it "should have a meaningful description" do
          matcher = callback(@callback_object_class).after(lifecycle).unless(:evaluates_to_false!)
          matcher.description.should == "callback Callback after #{lifecycle} unless evaluates_to_false! evaluates to false"
        end
      end
    end
  end
  
  context "on validation" do
    before do
     @callback_object_class = define_model(:callback) do
        define_method("before_validation"){}
        define_method("after_validation"){}
      end

      @callback_object_class2 = define_model(:callback2) do
        define_method("before_validation"){}
        define_method("after_validation"){}
      end

      callback_object = @callback_object_class.new
      callback_object2 = @callback_object_class2.new

      @callback_object_not_found_class = define_model(:callback_not_fount) do
        define_method("before_validation"){}
        define_method("after_validation"){}
      end
      @model = define_model(:example, :attr  => :string,
                                      :other => :integer) do
        before_validation :dance!, :if => :evaluates_to_false!
        after_validation  :shake!, :unless => :evaluates_to_true!
        before_validation :dress!, :on => :create
        after_validation  :shriek!, :on => :update, :unless => :evaluates_to_true!
        after_validation  :pucker!, :on => :save, :if => :evaluates_to_false!
        before_validation callback_object, :if => :evaluates_to_false!
        after_validation  callback_object, :unless => :evaluates_to_true!
        before_validation callback_object, :on => :create
        after_validation  callback_object, :on => :update, :unless => :evaluates_to_true!
        after_validation  callback_object2, :on => :save, :if => :evaluates_to_false!
        define_method(:dance!){}
        define_method(:shake!){}
        define_method(:dress!){}
        define_method(:shriek!){}
        define_method(:pucker!){}
      end.new
    end
    
    context "as a simple callback test" do
      it "should find the callback before the fact" do
        @model.should callback(:dance!).before(:validation)
      end
      it "should find the callback after the fact" do
        @model.should callback(:shake!).after(:validation)
      end
      it "should not find a callback around the fact" do
        @model.should_not callback(:giggle!).around(:validation)
      end
      it "should not find callbacks that are not there" do
        @model.should_not callback(:scream!).around(:validation)
      end
      it "should have a meaningful description" do
        matcher = callback(:dance!).before(:validation)
        matcher.description.should == "callback dance! before validation"
      end

      it "should find the callback before the fact" do
        @model.should callback(@callback_object_class).before(:validation)
      end
      it "should find the callback after the fact" do
        @model.should callback(@callback_object_class).after(:validation)
      end
      it "should not find a callback around the fact" do
        @model.should_not callback(@callback_object_class).around(:validation)
      end
      it "should not find callbacks that are not there" do
        @model.should_not callback(@callback_object_not_found_class).around(:validation)
      end
      it "should have a meaningful description" do
        matcher = callback(@callback_object_class).before(:validation)
        matcher.description.should == "callback Callback before validation"
      end
    end
    
    context "with additinal lifecycles defined" do
      it "should find the callback before the fact on create" do
        @model.should callback(:dress!).before(:validation).on(:create)
      end
      it "should find the callback after the fact on update" do
        @model.should callback(:shriek!).after(:validation).on(:update)
      end
      it "should find the callback after the fact on save" do
        @model.should callback(:pucker!).after(:validation).on(:save)
      end
      it "should not find a callback for pucker! after the fact on update" do
        @model.should_not callback(:pucker!).after(:validation).on(:update)
      end
      it "should have a meaningful description" do
        matcher = callback(:dance!).after(:validation).on(:update)
        matcher.description.should == "callback dance! after validation on update"
      end

      it "should find the callback before the fact on create" do
        @model.should callback(@callback_object_class).before(:validation).on(:create)
      end
      it "should find the callback after the fact on update" do
        @model.should callback(@callback_object_class).after(:validation).on(:update)
      end
      it "should find the callback after the fact on save" do
        @model.should callback(@callback_object_class2).after(:validation).on(:save)
      end
      it "should not find a callback for Callback after the fact on update" do
        @model.should_not callback(@callback_object_class2).after(:validation).on(:update)
      end
      it "should have a meaningful description" do
        matcher = callback(@callback_object_class).after(:validation).on(:update)
        matcher.description.should == "callback Callback after validation on update"
      end
    end
    
    context "with conditions" do
      it "should match the if condition" do
        @model.should callback(:dance!).before(:validation).if(:evaluates_to_false!)
      end
      it "should match the unless condition" do
        @model.should callback(:shake!).after(:validation).unless(:evaluates_to_true!)
      end
      it "should not find callbacks not matching the conditions" do
        @model.should_not callback(:giggle!).around(:validation).unless(:evaluates_to_false!)
      end
      it "should not find callbacks that are not there entirely" do
        @model.should_not callback(:scream!).before(:validation).unless(:evaluates_to_false!)
      end
      it "should have a meaningful description" do
        matcher = callback(:dance!).after(:validation).unless(:evaluates_to_false!)
        matcher.description.should == "callback dance! after validation unless evaluates_to_false! evaluates to false"
      end

      it "should match the if condition" do
        @model.should callback(@callback_object_class).before(:validation).if(:evaluates_to_false!)
      end
      it "should match the unless condition" do
        @model.should callback(@callback_object_class).after(:validation).unless(:evaluates_to_true!)
      end
      it "should not find callbacks not matching the conditions" do
        @model.should_not callback(@callback_object_class).around(:validation).unless(:evaluates_to_false!)
      end
      it "should not find callbacks that are not there entirely" do
        @model.should_not callback(@callback_object_not_found_class).before(:validation).unless(:evaluates_to_false!)
      end
      it "should have a meaningful description" do
        matcher = callback(@callback_object_class).after(:validation).unless(:evaluates_to_false!)
        matcher.description.should == "callback Callback after validation unless evaluates_to_false! evaluates to false"
      end
    end
    
    context "with conditions and additional lifecycles" do
      it "should find the callback before the fact on create" do
        @model.should callback(:dress!).before(:validation).on(:create)
      end
      it "should find the callback after the fact on update with the unless condition" do
        @model.should callback(:shriek!).after(:validation).on(:update).unless(:evaluates_to_true!)
      end
      it "should find the callback after the fact on save with the if condition" do
        @model.should callback(:pucker!).after(:validation).on(:save).if(:evaluates_to_false!)
      end
      it "should not find a callback for pucker! after the fact on save with the wrong condition" do
        @model.should_not callback(:pucker!).after(:validation).on(:save).unless(:evaluates_to_false!)
      end
      it "should have a meaningful description" do
        matcher = callback(:dance!).after(:validation).on(:save).unless(:evaluates_to_false!)
        matcher.description.should == "callback dance! after validation on save unless evaluates_to_false! evaluates to false"
      end

      it "should find the callback before the fact on create" do
        @model.should callback(@callback_object_class).before(:validation).on(:create)
      end
      it "should find the callback after the fact on update with the unless condition" do
        @model.should callback(@callback_object_class).after(:validation).on(:update).unless(:evaluates_to_true!)
      end
      it "should find the callback after the fact on save with the if condition" do
        @model.should callback(@callback_object_class2).after(:validation).on(:save).if(:evaluates_to_false!)
      end
      it "should not find a callback for Callback after the fact on save with the wrong condition" do
        @model.should_not callback(@callback_object_class).after(:validation).on(:save).unless(:evaluates_to_false!)
      end
      it "should have a meaningful description" do
        matcher = callback(@callback_object_class).after(:validation).on(:save).unless(:evaluates_to_false!)
        matcher.description.should == "callback Callback after validation on save unless evaluates_to_false! evaluates to false"
      end
    end
  end
  
  [:initialize, :find, :touch].each do |lifecycle|
    
    context "on #{lifecycle}" do
      before do

        @callback_object_class = define_model(:callback) do
          define_method("after_#{lifecycle}"){}
        end
        @callback_object_class2 = define_model(:callback2) do
          define_method("after_#{lifecycle}"){}
        end

        callback_object = @callback_object_class.new
        callback_object2 = @callback_object_class2.new

        @callback_object_not_found_class = define_model(:callback_not_fount) do
          define_method("after_#{lifecycle}"){}
        end

        @model = define_model(:example, :attr  => :string,
                                        :other => :integer) do
          send(:"after_#{lifecycle}", :dance!, :if => :evaluates_to_false!)
          send(:"after_#{lifecycle}", :shake!, :unless => :evaluates_to_true!)
          send(:"after_#{lifecycle}", callback_object, :if => :evaluates_to_false!)
          send(:"after_#{lifecycle}", callback_object2, :unless => :evaluates_to_true!)
          define_method(:shake!){}
          define_method(:dance!){}
          
          define_method :evaluates_to_false! do
            false
          end
          
          define_method :evaluates_to_true! do
            true
          end
          
        end.new
      end
      
      context "as a simple callback test" do
        it "should not find a callback before the fact" do
          @model.should_not callback(:dance!).before(lifecycle)
        end
        it "should find the callback after the fact" do
          @model.should callback(:shake!).after(lifecycle)
        end
        it "should not find a callback around the fact" do
          @model.should_not callback(:giggle!).around(lifecycle)
        end
        it "should not find callbacks that are not there" do
          @model.should_not callback(:scream!).around(lifecycle)
        end
        it "should have a meaningful description" do
          matcher = callback(:dance!).before(lifecycle)
          matcher.description.should == "callback dance! before #{lifecycle}"
        end

        it "should not find a callback before the fact" do
          @model.should_not callback(@callback_object_class).before(lifecycle)
        end
        it "should find the callback after the fact" do
          @model.should callback(@callback_object_class).after(lifecycle)
        end
        it "should not find a callback around the fact" do
          @model.should_not callback(@callback_object_class).around(lifecycle)
        end
        it "should not find callbacks that are not there" do
          @model.should_not callback(@callback_object_not_found_class).around(lifecycle)
        end
        it "should have a meaningful description" do
          matcher = callback(@callback_object_class).before(lifecycle)
          matcher.description.should == "callback Callback before #{lifecycle}"
        end
      end
      
      context "with conditions" do
        it "should match the if condition" do
          @model.should callback(:dance!).after(lifecycle).if(:evaluates_to_false!)
        end
        it "should match the unless condition" do
          @model.should callback(:shake!).after(lifecycle).unless(:evaluates_to_true!)
        end
        it "should not find callbacks not matching the conditions" do
          @model.should_not callback(:giggle!).around(lifecycle).unless(:evaluates_to_false!)
        end
        it "should not find callbacks that are not there entirely" do
          @model.should_not callback(:scream!).before(lifecycle).unless(:evaluates_to_false!)
        end
        it "should have a meaningful description" do
          matcher = callback(:dance!).after(lifecycle).unless(:evaluates_to_false!)
          matcher.description.should == "callback dance! after #{lifecycle} unless evaluates_to_false! evaluates to false"
        end
        it "should match the if condition" do
          @model.should callback(@callback_object_class).after(lifecycle).if(:evaluates_to_false!)
        end
        it "should match the unless condition" do
          @model.should callback(@callback_object_class2).after(lifecycle).unless(:evaluates_to_true!)
        end
        it "should not find callbacks not matching the conditions" do
          @model.should_not callback(@callback_object_class).around(lifecycle).unless(:evaluates_to_false!)
        end
        it "should not find callbacks that are not there entirely" do
          @model.should_not callback(@callback_object_not_found_class).before(lifecycle).unless(:evaluates_to_false!)
        end
        it "should have a meaningful description" do
          matcher = callback(@callback_object_class).after(lifecycle).unless(:evaluates_to_false!)
          matcher.description.should == "callback Callback after #{lifecycle} unless evaluates_to_false! evaluates to false"
        end
      end
      
    end
  end
end
