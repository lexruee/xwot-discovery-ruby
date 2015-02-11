module XwotDiscovery

  class Message

    attr_reader :method, :payload, :location,
                :content_type, :protocol, :urn, :hostname, :host

    def initialize(a_hash)
      @method = a_hash[:method]
      @location = a_hash[:location]
      @content_type = a_hash[:content_type]
      @payload = a_hash[:payload]
      @protocol = a_hash[:protocol] || ''
      @urn = a_hash[:urn]
      @host = a_hash[:host]
      @hostname = a_hash[:hostname]
    end

  end

end
