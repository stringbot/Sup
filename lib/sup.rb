require 'uri'
require 'net/http'

CONFIG = File.join(File.dirname(__FILE__), '..', 'config', 'config.yml')

class Sup
  def initialize()
    @config = read_config
  end

  def read_config
    YAML.load(File.open(CONFIG))
  end

  def servers
    @servers ||= @config[:servers]
  end

  def poll_all
    servers.each do |name, url|
      poll_server(name, url)
    end
  end

  def poll_server(name, address)
    uri = URI.parse(address)
    Net::HTTP.start(uri.host, uri.port) do |http|
      update_server_state(name, http.get(uri.path))
    end
  end

  def update_server_state(name, response)
  end
end