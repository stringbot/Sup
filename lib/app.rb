require 'rubygems'
require 'sinatra'
require 'net/http'
require 'uri'
require 'haml'
require 'sup'

set :views, File.dirname(__FILE__) + '/../views'

get "/" do
  @states = Sup.new.poll_all.states
  haml :index
end

helpers do
  def render_state(name,status)
    state = status.kind_of?(Net::HTTPSuccess) ? 'up' : 'down'
    "#{name} is #{state}"
  end
end