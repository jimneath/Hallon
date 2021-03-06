require 'ostruct' # https://github.com/rspec/rspec-core/issues/issue/264

describe Hallon::Session do
  # Hallon::Session#instance requires that a session have NOT been established,
  # thus its’ tests are declared in the spec_helper.rb
  
  context "once instantiated" do
    it_behaves_like "spotify objects" do
      describe "appkey" do
        it "should == Hallon::APPKEY" do session.appkey.should == Hallon::APPKEY end
      end
    
      describe "options" do
        subject { options }
        its([:user_agent]) { should == options[:user_agent] }
        its([:settings_path]) { should == options[:settings_path] }
        its([:cache_path]) { should == options[:cache_path] }
      end
    
      describe "#merge_defaults" do
        it "should return the defaults if no options given" do
          session.send(:merge_defaults, nil).should be_a Hash # values not important
        end
      
        it "should allow given options to override defaults" do
          session.send(:merge_defaults, :user_agent => "Cow")[:user_agent].should == "Cow"
        end
      end
    
      describe "#process_events" do
        it "should return the timeout" do
          session.process_events.should be_a Fixnum
        end
      end
    
      describe "#logout" do
        it "should check logged in status" do
          session.should_receive(:logged_in?).once
          expect { session.logout }.to_not raise_error
        end
      end
    end
  end
end