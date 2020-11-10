require 'minitest/autorun'
require 'minitest/mock'
require_relative '../lib/oauth'

class TestGetOAuthParams < Minitest::Test

  CONSUMER_KEY = 'aaa!aaa'.freeze
  MY_PAYLOAD = '{ my: "payload" }'.freeze

  def test_creates_map_with_ordered_oauth_parameters
    oauth_params = OAuth.get_oauth_params(CONSUMER_KEY)
    map_keys = oauth_params.keys
    params = %w[oauth_body_hash oauth_consumer_key oauth_nonce oauth_signature_method oauth_timestamp oauth_version]
    assert_equal(map_keys, params)
  end

  def test_creates_map_with_ordered_oauth_parameters_with_payload
    oauth_params = OAuth.get_oauth_params(CONSUMER_KEY, MY_PAYLOAD)
    map_keys = oauth_params.keys
    params = %w[oauth_body_hash oauth_consumer_key oauth_nonce oauth_signature_method oauth_timestamp oauth_version]
    assert_equal(map_keys, params)
  end
end
