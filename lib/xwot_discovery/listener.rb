module XwotDiscovery

  class Listener



  end

  class MockListener < Listener

    def alive(message)
      p message
      p 'alive method called'
    end

    def find(message)
      #p message
      p 'find method called'
    end

    def bye(message)
      #p message
      p 'bye method called'
    end

    def update(message)
      #p message
      p 'update method called'
    end

  end

end
