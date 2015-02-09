module XwotDiscovery

  class Message

    attr_reader :method, :payload, :location, :content_type

    def initialize(a_hash)
      @method = a_hash[:method]
      @location = a_hash[:location]
      @content_type = a_hash[:content_type]
      @payload = a_hash[:payload]
    end

  end

end
