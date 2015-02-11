require 'socket'
require 'ipaddr'
require 'json'

require 'xwot_discovery/version'
require 'xwot_discovery/message'
require 'xwot_discovery/protocol'
require 'xwot_discovery/service_listener'
require 'xwot_discovery/service_protocol'
require 'xwot_discovery/service'
require 'xwot_discovery/resource'


module XwotDiscovery

  def self.service
    if @service.nil?
      init
      @service.start
      @service
    else
      @service
    end
  end

  private

  def self.init
    @protocol ||=  XwotProtocol.new
    @service_protocol ||= XwotServiceProtocol.new(@protocol)
    @service ||= XwotService.new @service_protocol
  end

end
