require 'spec_helper'

module XwotDiscovery

  describe Service do

    it "creates a discovery service" do
      service = Service.new(MockDiscoverStrategy.new)

    end

  end

end
