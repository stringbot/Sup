$:.push File.join(File.dirname(__FILE__), '..', 'lib')
require 'test/unit'
require 'rubygems'
require 'shoulda'
require 'mocha'
require 'sup'


class SupTest < Test::Unit::TestCase
  context "a new Sup instance" do
    setup do
      @sup = Sup.new
    end

    before_should "read server configs from a yml file" do
      YAML.expects(:load)
    end
  end

  context "when polling" do
    setup do
      @sup = Sup.new
      @sup.poll
    end

    before_should "attempt to reach the server at the specified url" do
      fake_config = {:servers =>
        {:test1 => 'http://fake.server/index.html'}
      }
      Sup.any_instance.expects(:read_config).returns(fake_config)
      Net::HTTP.expects(:start).yields(mock(:get))
    end

    should "display the HTTP status returned by the request" do

    end
  end

end
