require 'uri'
require 'net/http'

CONFIG = File.join(File.dirname(__FILE__), '..', 'config', 'config.yml')

class Sup
  attr_reader :states

  def initialize()
    @config = read_config
    @states = {}
  end

  def read_config
    YAML.load(File.open(CONFIG))
  end

  def servers
    @servers ||= @config['servers']
  end

  def poll_all
    servers.each do |name, url|
      poll_server(name, url)
    end
  end

  def poll_server(name, address)
    uri = URI.parse(address)
    Net::HTTP.start(uri.host, uri.port) do |http|
      path = uri.path.empty? ? '/' : uri.path
      update_server_state(name, http.get(path))
    end
  end

  def update_server_state(name, response)
    @states[name] = response
  end
end