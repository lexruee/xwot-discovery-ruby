require 'spec_helper'

module XwotDiscovery

  class MyListener < BaseListener

    def alive(message)
      #p 'alive received!!'
      #p message
    end

    def find(message, service)
      #p 'find received!!'
      #p message
    end

  end

  describe "XwotDiscovery.service" do

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
      s = XwotDiscovery.service
      s.register_listener(MyListener.new)
    end

    it "#register_device" do
      s = XwotDiscovery.service
      s.register_resource(@resource)
      #sleep 120 * 2
    end

    it "#find" do
      s = XwotDiscovery.service
      s.find 'urn:xwot:temperature-sensor'
      s.find

      s.find 'urn:xwot:temperature-sensor' do |message|
        p 'callback!!'
        p message.urn
      end
      sleep 120 * 2
    end

  end


end
