require 'spec_helper'

describe ErrorTracker do
  # Reload Singleton
  before(:each) { load File.expand_path('../../../lib/error_tracker/notifier.rb', __FILE__) }

  before do
    class DummyTracker < ErrorTracker::Adapter
      def self.perform(exception, custom = {}, request = {})
        "dummy tracker says: #{exception.message}"
      end
    end

    class SomeOtherDummyTracker < ErrorTracker::Adapter
      def self.perform(exception, custom = {}, request = {})
        "some other dummy tracker says: #{exception.message}"
      end
    end
  end

  context ".register" do
    it "registers a class with the error tracker" do
      ErrorTracker.register(DummyTracker)
      expect(ErrorTracker::Notifier.instance.registered_classes).to eq([DummyTracker])
    end

    it "can register a class as a string" do
      ErrorTracker.register("DummyTracker")
      expect(ErrorTracker::Notifier.instance.registered_classes).to eq(["DummyTracker"])
    end

    it "can register a class as a block" do
      ErrorTracker.register do |exception, custom, request|
        "block tracker says: #{exception.message}"
      end

      expect(ErrorTracker::Notifier.instance.registered_classes.first).to be_a(Proc)

      result = ErrorTracker.track(Exception.new("hello"))
      expect(result).to eq(["block tracker says: hello"])
    end

    it "can register multiple classes at the same time" do
      ErrorTracker.register(DummyTracker, SomeOtherDummyTracker)
      expect(ErrorTracker::Notifier.instance.registered_classes).to eq([DummyTracker, SomeOtherDummyTracker])
    end

    it "can register multiple classes in consequent calls" do
      ErrorTracker.register(DummyTracker)
      ErrorTracker.register(SomeOtherDummyTracker)
      expect(ErrorTracker::Notifier.instance.registered_classes).to eq([DummyTracker, SomeOtherDummyTracker])
    end

    it "silently ignores the call if the class is being added twice" do
      ErrorTracker.register(DummyTracker)
      expect(ErrorTracker.register(DummyTracker)).to be_false
      expect(ErrorTracker::Notifier.instance.registered_classes).to eq([DummyTracker])
    end
  end

  context ".track" do
    context "passing only the exception argument" do
      context "if no classes are registered with the error tracker" do
        it "returns an empty array" do
          result = ErrorTracker.track(Exception.new("hello"))
          expect(result).to be_empty
        end
      end

      context "if classes are registered with the error tracker" do
        before { ErrorTracker.register(DummyTracker, SomeOtherDummyTracker) }

        it "returns an array containing the return values of all registered perform methods" do
          result = ErrorTracker.track(Exception.new("hello"))
          expect(result).to eq(["dummy tracker says: hello", "some other dummy tracker says: hello"])
        end
      end

      context "if a class registered with the error tracker doesn't extend the adapter" do
        before do
          class NotAnAdapterTracker
            def self.perform(exception, custom = {}, request = {})
              "not an adapter tracker says: #{exception.message}"
            end
          end

          ErrorTracker.register(NotAnAdapterTracker)
        end

        it "silently bypasses the registered tracker" do
          expect(ErrorTracker::Notifier.instance.registered_classes).to eq([NotAnAdapterTracker])
          result = ErrorTracker.track(Exception.new("hello"))
          expect(result).to be_empty
        end
      end
    end

    context "passing the custom argument" do
      before do
        ErrorTracker.register do |exception, custom, request|
          "#{exception.message} #{custom.to_a.to_s}"
        end
      end

      it "passes the custom hash argument to the tracker" do
        result = ErrorTracker.track(Exception.new("hello"),  a: 1, b: "something")
        expect(result).to eq(["hello [[:a, 1], [:b, \"something\"]]"])
      end
    end

    context "passing the request argument" do
      before do
        ErrorTracker.register do |exception, custom, request|
          "#{exception.message} #{request.to_a.to_s}"
        end
        ErrorTracker::Context.env = { a: 2, b: "something else" }
      end

      it "passes the request argument to the tracker" do
        result = ErrorTracker.track(Exception.new("hello"))
        expect(result).to eq(["hello [[:a, 2], [:b, \"something else\"]]"])
      end
    end
  end

end
