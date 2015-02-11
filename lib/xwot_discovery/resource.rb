module XwotDiscovery

  class XwotResource

    attr_reader :description, :urn, :interface, :location

    def initialize(a_hash)
      @urn = a_hash[:urn]
      @location = a_hash[:location]
      @interface = a_hash[:interface]
      @description = a_hash[:description]
    end

    def payload
      JSON.generate(@description)
    end

  end

end
