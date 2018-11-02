require 'minitest/autorun'
require 'test/unit'
require 'minitest/mock'
require_relative '../lib/oauth'

class TestGetTimeStamp < Minitest::Test

  def test_creates_UNIX_timestamp_UTC
    timestamp = OAuth.time_stamp
    assert_equal(timestamp > 0, true)
  end
end
