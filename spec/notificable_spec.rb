require "spec_helper"
require "json"

RSpec.describe Notificable::Core do
  it "has a version number" do
    expect(Notificable::VERSION).not_to be nil
  end

  describe "publish" do
    before do
      @notificable_core = Notificable::Core.new({message: "Lorem ipsum dolor sit amet."})
    end
    context "successful" do
      it "should broadcast" do
        expect {
          @notificable_core.execute
        }.to broadcast(:successful, {message: "Lorem ipsum dolor sit amet."})
      end
    end

    context "failure" do
      before do
        @notificable_core = Notificable::Core.new([1,2,3])
      end
      it "should broadcast failed" do
        expect {
          @notificable_core.execute
        }.to broadcast(:failed, [1, 2, 3])
      end
    end
  end


  describe "given a piece of code invoking a publisher" do
    class CodeThatReactsToEvents
      def do_something
        publisher = Notificable::Core.new({message: "testing"})
        publisher.on(:successful) do |notification|
          # DO NOT REMOVE THE RETURN KEYWORD
          return "Hello with: #{notification[:message]}!"
        end
        publisher.on(:failed) do |notification|
          # DO NOT REMOVE THE RETURN KEYWORD
          return "Invalid notification!"
        end
        publisher.execute
      end
    end

    context "when stubbing the publisher to emit a successful event" do
      before do
        stub_wisper_publisher("Notificable::Core", :execute, :successful, {message: "testing"})
      end

      it "emits the event" do
        response = CodeThatReactsToEvents.new.do_something
        expect(response).to eq "Hello with: testing!"
      end
    end

    context "when stubbing the publisher to emit a failed event" do
      before do
        stub_wisper_publisher("Notificable::Core", :execute, :failed, {message: "testing"})
      end

      it "emits the event" do
        response = CodeThatReactsToEvents.new.do_something
        expect(response).to eq "Invalid notification!"
      end
    end
  end
end
