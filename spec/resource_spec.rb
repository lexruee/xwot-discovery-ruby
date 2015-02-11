require 'spec_helper'

module XwotDiscovery

  describe XwotResource do

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
    end

    it ".new" do
      res = XwotResource.new @a_hash
      expect(res.urn).to_not be_nil
      expect(res.location).to_not be_nil
      expect(res.description).to_not be_nil
      expect(res.interface).to_not be_nil
    end

  end


end
