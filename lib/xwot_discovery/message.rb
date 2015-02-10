module XwotDiscovery

  class Message

    attr_reader :method, :payload, :location,
                :content_type, :protocol, :resource

    def initialize(a_hash)
      @method = a_hash[:method]
      @location = a_hash[:location]
      @content_type = a_hash[:content_type]
      @payload = a_hash[:payload]
      @protocol = a_hash[:protocol] || ''
      @resource = a_hash[:resource]
    end

  end

end
