require 'test_helper'

class SupTest < Test::Unit::TestCase
  context "a new Sup instance" do
    setup do
      @sup = Sup.new
    end

    before_should "read server configs from a yml file" do
      YAML.expects(:load)
    end
  end

  context "polling with Sup" do
    setup do
      fake_config = {'servers' =>
        {'test1' => 'http://fake.server/index.html'}
      }
      Sup.any_instance.expects(:read_config).returns(fake_config)
      @sup = Sup.new
      @resp = @sup.poll_all
    end

    before_should "attempt to reach the server at the specified url" do
      Net::HTTP.expects(:start).yields(mock(:get))
    end

    before_should "update the results with the http response" do
      fake_response = mock
      Net::HTTP.expects(:start).yields(mock(:get => fake_response))
      Sup.any_instance.expects(:update_server_state).with(anything, fake_response)
    end

    before_should "not raise errors when host is unreachable" do
      Net::HTTP.expects(:start).raises(SocketError, "host no reachy")
    end
  end
end
