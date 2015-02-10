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

    def register(listener)
      @listeners << listener
    end

    def unregister(listener)
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

    def find(resource = '')
      resource_str = case resource.to_s
      when 'all'
        '*'
      when ''
        '*'
      else
        resource
      end
      # TODO: registry lookup
      @protocol.send(Message.new({
        method: 'find',
        resource: resource_str
      }))
    end

  end

end
