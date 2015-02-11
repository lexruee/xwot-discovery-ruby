require 'spec_helper'

module XwotDiscovery

  #
  # The MockProtocol implements a mock discovery protocol.
  # It's used to test the main protocol logic of the service protocol.
  #
  class MockProtocol < Protocol

    def listen
      p 'listen'
      receive
    end

    def close
      p 'close'
    end

    def send(message)
      p 'send'
      p message
    end

    def receive
      p 'receive'
      message = Message.new(method: 'alive',
      host: '224.0.0.15:2015',
      content_type: 'application/json',
      payload: '{ "property": "value" }',
      location: 'http://10.0.0.26/test')
      @observer.dispatch(message)
    end

    def notify_me(subject)
      p 'notify_me called'
      @observer = subject
    end

  end

  class MockListener < ServiceListener

    def alive(message)
      p message
      p 'alive method called'
    end

    def find(message, service)
      p message
      p 'find method called'
    end

    def bye(message)
      p message
      p 'bye method called'
    end

    def update(message)
      p message
      p 'update method called'
    end

  end

  describe XwotServiceProtocol do
    before do
      @protocol =  XwotProtocol.new
      @service_protocol = XwotServiceProtocol.new(@protocol)
    end

    describe "#start" do
      it "starts the service" do
        @service_protocol.start
      end
    end

    describe "#register" do

      it "handles an incoming message" do
        @service_protocol.register_listener(MockListener.new)
        @protocol.listen
        message = Message.new(
          method: 'alive',
          content_type: 'application/json',
          payload: '{ "property": "value" }',
          location: 'http://10.0.0.26/test'
        )
        @protocol.send(message)
        @service_protocol.find
        loop do

        end
      end

    end

    describe "#shutdown" do
      it "shuts down the service" do
        @service.shutdown
      end
    end

  end

end
