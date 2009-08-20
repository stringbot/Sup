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
    self
  end

  def poll_server(name, address)
    uri = URI.parse(address)
    begin
      timeout(5) do
        print "#{Time.now}: checking #{name} at #{address} ... "
        Net::HTTP.start(uri.host, uri.port) do |http|
          http.read_timeout = 10
          path = uri.path.empty? ? '/' : uri.path
          update_server_state(name, address, http.get(path))
          puts "ok"
        end
      end
    rescue Timeout::Error, SocketError => e
      puts "Error: #{e.message}"
      update_server_state(name, address, :unreachable)
    end
  end

  def update_server_state(name, address, response)
    @states[name] = {:url => address, :response => response }
  end
end