require 'xwot_discovery'

class MyListener < XwotDiscovery::BaseListener

  def alive(message)
    puts "received alive msg:\n"
    mprint(message)
  end

  def bye(message)
    puts "received bye msg:\n"
    mprint(message)
  end

  def mprint(message)
    m = ''
    m += "\thostname: #{message.hostname}\n"
    m += "\thost: #{message.host}\n"
    m += "\tlocation: #{message.location}\n"
    m += "\turn: #{message.urn}\n\n"
    puts m
  end

end

XwotDiscovery.service.register_listener(MyListener.new)

loop { }
