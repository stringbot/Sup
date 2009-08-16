require 'uri'
require 'net/http'

CONFIG = File.join('..', 'config', 'config.yml')

class Sup
  def initialize()
    @config = read_config
  end

  def read_config
    YAML.load(File.open(CONFIG))
  end

  def poll
    @config[:servers].each do |name, url|
      uri = URI.parse(url)
      Net::HTTP.start(uri.host, uri.port) do |http|
        http.get(uri.path)
      end
    end
  end
end