module XwotDiscovery

  class ServiceListener

    def alive(message)
      raise 'not implemented!'
    end

    def find(message, service = nil)
      raise 'not implemented!'
    end

    def bye(message)
      raise 'not implemented!'
    end

    def update(message)
      raise 'not implemented!'
    end

  end


  class BaseListener < ServiceListener

    def alive(message)
      # do nothing
    end

    def find(message, service = nil)
      # do nothing
    end

    def bye(message)
      # do nothing
    end

    def update(message)
      # do nothing
    end

  end

end
