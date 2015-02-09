module XwotDiscovery

  class Service

    def initialize(protocol)
      @protocol = protocol
      @listeners = []
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
        case message.method
        when 'alive'
          listener.alive(message)
        when 'update'
          listener.update(message)
        when 'find'
          listener.find(message)
        when 'bye'
          listener.bye(message)
        else
          # do nothing
        end
      end
    end

  end

end
