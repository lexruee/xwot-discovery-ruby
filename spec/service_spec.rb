require 'spec_helper'

module XwotDiscovery

  describe Service do
    before do
      @protocol =  XwotProtocol.new
      @service = Service.new(@protocol)
    end

    describe "#start" do
      it "starts the service" do
        @service.start
      end
    end

    describe "#register" do

      it "handles an incoming message" do
        @service.register(MockListener.new)
        @protocol.listen
        message = Message.new(method: 'alive',
        host: '224.0.0.15:2015',
        content_type: 'application/json',
        payload: '{ "property": "value" }',
        location: 'http://10.0.0.26/test')
        @protocol.send(message)
        @protocol.send(message)
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
