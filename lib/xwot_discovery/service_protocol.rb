module XwotDiscovery

  class XwotServiceProtocol

    class Registry

      def initialize
        @registry = {}
      end

      def add(message)
        @registry[message.location] ||= {
          uri: message.location,
          message: message
        }
      end

      def update(message)
        @registry[message.location] = {
          uri: message.location,
          message: message
        }
      end

      def remove(message)
        @registry.delete(message.location)
      end

    end

    def initialize(protocol)
      @protocol = protocol
      @listeners = []
      @find_callbacks = []
      @registry = Registry.new
      @protocol.notify_me(self)
    end

    def start
      @protocol.listen
    end

    def shutdown
      @protocol.close
    end

    def register_listener(listener)
      @listeners << listener
    end

    def unregister_listener(listener)
      @listeners.delete(listener)
    end

    def dispatch(message)
      @listeners.each do |listener|
        case message.method.downcase
        when 'alive'
          @registry.add(message)
          listener.alive(message)
        when 'update'
          @registry.update(message)
          listener.update(message)
        when 'find'
          listener.find(message, self)
        when 'bye'
          @registry.remove(message)
          listener.bye(message)
        else
          # do nothing
        end
      end
    end

    def find(urn = '')
      urn_str = case urn.to_s
      when '*'
        '*'
      when ''
        '*'
      else
        urn
      end
      # TODO: registry lookup
      message = Message.new({
        method: 'find',
        urn: urn_str})
      p message
      @protocol.send(message)
    end

    def alive(resource)
      message = Message.new({
        method: 'alive',
        urn: resource.urn,
        location: resource.location,
        content_type: 'application/json',
        payload: resource.payload})
      @protocol.send(message)
    end

    def bye(resource)
      message = Message.new({
        method: 'bye',
        urn: resource.urn,
        location: resource.location,
        content_type: 'application/json',
        payload: resource.payload})
      @protocol.send(message)
    end

    def update(resource)
      message = Message.new({
        method: 'update',
        urn: resource.urn,
        location: resource.location,
        content_type: 'application/json',
        payload: resource.payload})
      @protocol.send(message)
    end

  end

end
