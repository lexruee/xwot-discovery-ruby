require 'spec_helper'

module XwotDiscovery

  class MyListener < BaseListener

    def alive(message)
      p 'alive received!!'
      p message
    end

  end

  describe XwotService do

    before do
      @a_hash = {
        urn: 'urn:xwot:temperature-sensor',
        location: 'http://10.0.0.33/temperature-sensor',
        description: {
          name: 'a temperature sensor',
          room: 'blah blah'
        },
        interface: {
          'http://10.0.0.33/temperature-sensor' => {
            input: [],
            output: [ :xml, :json, :html ],
            method: :get,
          }
        }
      }
      @resource =  XwotResource.new @a_hash
      @protocol =  XwotProtocol.new
      @service_protocol = XwotServiceProtocol.new(@protocol)
      @service = XwotService.new @service_protocol
      @service.register_listener(MyListener.new)
    end

    it "#register_device" do
      @service.register_resource(@resource)
      @service.start
      loop do

      end
    end

  end


end
