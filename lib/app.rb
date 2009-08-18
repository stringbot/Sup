require 'rubygems'
require 'sinatra'
require 'net/http'
require 'uri'

get "/" do
  @sup = Sup.new.poll_all

  # status_hash = is_finance_running?("web1va", "web2va", "web3va", "dev02")
  # output = style_tag
  # output << "<div id='container'>"
  # output << "<h1>Is Finan<span>&#162;</span>e App Running?</h1>"
  # status_hash.each do |host,value|
  #   status = value ? 'up' : 'down'
  #   output << "<div class='#{status}'>Finance is #{status} on <span class='host'>#{host}</span>.</div>"
  # end
  # output << "</div>"
  # output.join
end

helpers do
  def is_finance_running?(*servers)
    status_hash = {}
    servers.each do |host|
      Net::HTTP.start("#{host}", 80) do |http|
        response = http.head('/customers.js?name=22%20Squared')
        status_hash[host] = response.kind_of?(Net::HTTPSuccess)
      end
    end
    status_hash
  end

  def style_tag
    ["<style>
      body { font-family: \"Lucida Grande\", sans-serif; width: 640px; margin: 2em auto; background-color: #eeefff; }
       h1 { margin-top: 0; }
       #container {  text-align: center; padding: 2em; -moz-border-radius: 5px; border: 1px solid #666; background-color: white; }
       .host { text-transform: uppercase; font-weight: bold; }
      .up { color: green; }
      .down { color: red; }
      </style>"]
  end
end