require 'xwot_discovery'
require 'sinatra'
require 'socket'

addr_info = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}
ip = addr_info.ip_address
port = 4567
a_hash = {
  urn: 'urn:xwot:temperature-sensor',
  location: "http://#{ip}:#{port}/temperature-sensor",
  description: {
    name: 'a temperature sensor',
    room: 'blah blah'
  },
  interface: {
    'http://10.0.0.33/temperature-sensor' => {
      input: [],
      output: [ :xml, :json, :html ],
      method: :get,
    }
  }
}

resource = XwotDiscovery::XwotResource.new a_hash
XwotDiscovery.service.register_resource(resource)

set :bind, '0.0.0.0'
get '/temperature-sensor' do
  'hello world!'
end

get '/' do
  'hello world'
end
