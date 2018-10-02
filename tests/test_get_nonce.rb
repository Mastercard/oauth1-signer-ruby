require 'test/unit'
require 'minitest/test'
require_relative '../lib/oauth'

class TestGetNonce < Test::Unit::TestCase

  NONCE_LENGTH = 32
  VALID_CHARS = Regexp.new('^[a-zA-Z0-9_]*$').freeze

  def test_creates_UUID_with_dashes_removed

    nonce = OAuth.get_nonce

    assert_equal(nonce.length, NONCE_LENGTH)
    assert_true(VALID_CHARS.match?(nonce))
  end
end
