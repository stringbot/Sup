require 'test_helper'
require 'ruby-debug'

class SupTest < Test::Unit::TestCase
  context "a new Sup instance" do
    setup do
      @sup = Sup.new
    end

    before_should "read server configs from a yml file" do
      YAML.expects(:load)
    end
  end

  context "expectations for polling with Sup" do
    setup do
      Sup.any_instance.expects(:read_config).returns(fake_config)
      @resp = Sup.new.poll_all.states
    end

    before_should "attempt to reach the server at the specified url" do
      Net::HTTP.expects(:start).yields(mock(:get))
    end

    before_should "update the results with the http response" do
      fake_response = mock
      Net::HTTP.expects(:start).yields(mock(:get => fake_response))
      Sup.any_instance.expects(:update_server_state).with(anything, anything, fake_response)
    end

    before_should "not raise errors when host is unreachable" do
      Net::HTTP.expects(:start).raises(SocketError, "host no reachy")
    end
  end

  context "polling with Sup" do
    setup do
      fake_response = "FAKE RESPONSE"
      Sup.any_instance.expects(:read_config).returns(fake_config)
      Net::HTTP.stubs(:start).yields(stub(:get => fake_response))
      @resp = Sup.new.poll_all.states
    end

    should "return a hash with the server name as the key" do
      @resp.keys.include? 'test1'
    end

    should "include the url and status in the hash value" do
      state = @resp['test1']
      assert_equal 'http://fake.server/index.html', state[:url]
      assert_equal 'FAKE RESPONSE', state[:response]
    end
  end

  def fake_config
    {'servers' =>
      {'test1' => 'http://fake.server/index.html'}
    }
  end
end
