require 'test_helper'
require 'rack/test'
require 'app'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # context "a get to index" do
  #   should "be ok" do
  #     get "/"
  #     assert last_response.ok?
  #   end
  # end
end