require 'minitest/autorun'
require 'minitest/mock'
require_relative '../lib/oauth'

class TestGetBodyHash < Minitest::Test

  def test_creates_base64_encoded_cryptographic_hash_of_the_given_payload
    my_payload = '{ my: "payload" }'
    body_hash = OAuth.get_body_hash my_payload

    assert_equal body_hash, 'Qm/nLCqwlog0uoCDvypgninzNQ25YHgTmUDl/zOgT1s='
  end
end