module XwotDiscovery

  #
  # An interface for a discovery protocol.
  #
  class Protocol

    def listen
      raise 'not implemented!'
    end

    def close
      raise 'not implemented!'
    end

    def send(message)
      raise 'not implemented!'
    end

    def receive
      raise 'not implemented!'
    end

    def notify_me(subject)
      raise 'not implemented!'
    end

  end


  #
  # The MockProtocol implements a mock discovery protocol.
  # It's used to the test main protocol logic of the service.
  #
  class MockProtocol < Protocol

    def listen
      p 'listen'
      receive
    end

    def close
      p 'close'
    end

    def send(message)
      p 'send'
      p message
    end

    def receive
      p 'receive'
      message = Message.new(method: 'alive',
        host: '224.0.0.15:2015',
        content_type: 'application/json',
        payload: '{ "property": "value" }',
        location: 'http://10.0.0.26/test')
      @observer.dispatch(message)
    end

    def notify_me(subject)
      p 'notify_me called'
      @observer = subject
    end

  end


  #
  # The Xwot Protocol Discovery implements the protocol interface.
  #
  class XwotProtocol < Protocol

    TTL = 1 # time-to-live
    MULTICAST_ADDR = "224.0.0.15" # multicast group
    BIND_ADDR = "0.0.0.0"
    PORT = 2015

    NAME = "XWOT-DISCOVERY"
    VERSION = "1.0"
    CRLN = "\r\n"
    FLAGS = 0

    RECEIVE_MAX_BYTES = 256

    def initialize
      @socket = nil
      @observer = nil
    end

    def listen
      init
      Thread.new do
        loop do
          Thread.start(receive) do |data|
            lines = data.split(CRLN)
            msg_hash = parse(lines)
            message = Message.new(msg_hash)
            #puts "#{Thread.current} - #{msg_hash}\n"
            @observer.dispatch(message)
          end
        end
      end
    end

    def parse(lines)
      msg_hash = {}
      payload = false
      lines.each_with_index do |line, index|
        if index == 0
          method, _ = line.split(' ')
          msg_hash[:method] = method
        elsif payload
          msg_hash[:payload] ||= []
          msg_hash[:payload] << line
        elsif !line.empty?
          header_field, header_value = line.split(' ')
          header_field = header_field[0...-1].downcase.tr('-','_').to_sym
          msg_hash[header_field] = header_value
        elsif line.empty?
          payload = true
        end
      end
      msg_hash[:payload] = msg_hash[:payload].join('')
      msg_hash
    end

    def close
      @socket.close if !@socket.nil?
    end

    def send(message)
      client_socket = UDPSocket.open
      client_socket.setsockopt(:IPPROTO_IP, :IP_MULTICAST_TTL, TTL)
      msg = ""
      msg += "#{message.method} * #{NAME}/#{VERSION}#{CRLN}"
      msg += "HOST: #{MULTICAST_ADDR}:#{PORT}#{CRLN}"
      msg += "LOCATION: #{message.location}#{CRLN}"
      msg += "CONTENT-TYPE: #{message.content_type}#{CRLN}"
      msg += "#{CRLN}"
      msg += "#{message.payload}#{CRLN}"
      msg += "#{CRLN}"
      client_socket.send(msg, FLAGS, MULTICAST_ADDR, PORT)
      client_socket.close
    end

    def receive
      data, _ = @socket.recvfrom(RECEIVE_MAX_BYTES)
      data
    end

    def notify_me(subject)
      @observer = subject
    end

    private

    def init
      @socket = UDPSocket.new(Socket::AF_INET)
      membership  = IPAddr.new(MULTICAST_ADDR).hton + IPAddr.new(BIND_ADDR).hton
      @socket.setsockopt(:IPPROTO_IP, :IP_ADD_MEMBERSHIP, membership)
      @socket.setsockopt(:SOL_SOCKET, :SO_REUSEPORT, 1)
      @socket.bind(BIND_ADDR, PORT)
    end

  end

end
