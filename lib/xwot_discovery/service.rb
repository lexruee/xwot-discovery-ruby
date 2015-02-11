module XwotDiscovery

  class XwotService

    ALIVE_INTERVAL_SECONDS = 5

    class ServiceProtocolListener < BaseListener

      def initialize(service, resources)
        @service = service
        @resources = resources
      end

      def alive(message)
        remove = []
        @service.find_callbacks.each do |tuple|
          urn, callback = tuple
          if urn == message.urn
            callback.call(message)
            remove << tuple
          end
        end
        @service.find_callbacks = @service.find_callbacks - remove
      end

      def find(message, service)
        if message.urn == '*'
          @resources.each { |resource| @service.send_alive(resource) }
        else
          filtered = @resources.select { |resource| resource.urn == message.urn }
          filtered.each { |resource| @service.send_alive(resource) }
        end
      end

    end

    attr_accessor :find_callbacks

    def initialize(service_protocol)
      @service_protocol = service_protocol
      @resources = []
      @rand = rand * 2 * 60
      @find_callbacks = []
      listener = ServiceProtocolListener.new(self, @resources)
      @service_protocol.register_listener(listener)
    end

    def start
      @service_protocol.start
      p @rand
      Thread.new do
        sleep @rand
        loop do
          @resources.each { |resource| send_alive(resource) }
          sleep ALIVE_INTERVAL_SECONDS
        end
      end
    end

    def find(urn = '*', &block)
      if block_given?
        @find_callbacks << [urn, block]
      end
      @service_protocol.find(urn)
    end

    def register_resource(resource)
      @resources << resource
      send_alive(resource)
    end

    def unregister_resource(resource)
      @resources.delete(resource)
      send_bye(resource)
    end

    def register_listener(listener)
      @service_protocol.register_listener(listener)
    end

    def unregister_listener(listener)
      @service_protocol.unregister_listener(listener)
    end


    def send_alive(resource)
      2.times do
        @service_protocol.alive(resource)
        sleep 0.5
      end
    end

    def send_bye(resource)
      2.times do
        @service_protocol.bye(resource)
        sleep 0.5
      end
    end

  end

end
