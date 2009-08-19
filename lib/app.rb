require 'rubygems'
require 'sinatra'
require 'net/http'
require 'uri'
require 'erb'
require 'sup'

get "/" do
  @states = Sup.new.poll_all
  @butts = "CHOLO"
  erb :index
end

helpers do
  def render(states)

  end

  def render_state(name,status)
    state = status.kind_of?(Net::HTTPSuccess) ? 'up' : 'down'
    "<div class='#{state}'>#{name} is #{state}</div>"
  end
end