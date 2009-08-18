require 'test_helper'
require 'rack/test'
require 'app'

class AppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context "a get to index" do
    setup do
      get "/"
    end

    before_should "use a Sup instance" do
      Sup.expects(:new).returns(mock(:poll_all))
    end
  end
end