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


  class BaseListener

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

  class MockListener < ServiceListener

    def alive(message)
      p message
      p 'alive method called'
    end

    def find(message, service)
      p message
      p 'find method called'
    end

    def bye(message)
      p message
      p 'bye method called'
    end

    def update(message)
      p message
      p 'update method called'
    end

  end

end
