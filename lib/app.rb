require 'rubygems'
require 'sinatra'
require 'net/http'
require 'uri'
require 'haml'
require 'sup'

set :views, File.dirname(__FILE__) + '/../views'
set :public, File.dirname(__FILE__) + '/../public'

get "/" do
  @states = Sup.new.poll_all.states
  haml :index
end

helpers do
  def render_state(name,url,status)
    state = css_for status
    "<span class='host'>#{name}</span> is #{state} at #{url}"
  end

  def css_for(status)
    status.kind_of?(Net::HTTPSuccess) ? 'up' : 'down'
  end
end