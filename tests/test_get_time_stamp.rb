require 'test/unit'
require 'minitest/mock'
require_relative '../lib/oauth'

class TestGetTimeStamp < Test::Unit::TestCase

  def test_creates_UNIX_timestamp_UTC
    timestamp = OAuth.time_stamp
    assert_true(timestamp > 0)
  end
end
