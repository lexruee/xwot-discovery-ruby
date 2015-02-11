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
  # Prototype: The Xwot Protocol Discovery implements the protocol interface.
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
      msg_hash = {
        method: '',
        protocol: '',
        urn: '*',
        payload: []
      }

      payload = false
      lines.each_with_index do |line, index|
        if index == 0
          method, urn, protocol = line.split(' ')
          msg_hash[:method] = method
          msg_hash[:protocol] = protocol
          msg_hash[:urn] = urn
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

      urn = if message.urn.nil?
        '*'
      else
        message.urn
      end

      msg = ""
      msg += "#{message.method} #{urn} #{NAME}/#{VERSION}#{CRLN}"
      msg += "HOST: #{MULTICAST_ADDR}:#{PORT}#{CRLN}"
      msg += "HOSTNAME: #{Socket.gethostname}#{CRLN}"

      if ['alive', 'bye', 'update'].include?(message.method)
        msg += "LOCATION: #{message.location}#{CRLN}"
        msg += "CONTENT-TYPE: #{message.content_type}#{CRLN}"
        msg += "#{CRLN}"
        msg += "#{message.payload}#{CRLN}"
      end

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
