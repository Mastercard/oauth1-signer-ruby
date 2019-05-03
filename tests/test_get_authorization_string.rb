require 'minitest/autorun'
require 'test/unit'
require 'minitest/mock'
require_relative '../lib/oauth'


class TestGetAuthorizationString < Minitest::Test

  # Creates a valid OAuth1.0a signature with a body hash when payload is present
  def test_get_authorization_string
    consumer_key = 'aaa!aaa'

    OAuth.stub(:get_nonce, "uTeLPs6K") do
      OAuth.stub(:time_stamp, "1524771555") do
        oauth_params = OAuth.get_oauth_params consumer_key
        authorization_string = OAuth.get_authorization_string oauth_params
        assert_equal authorization_string, 'OAuth oauth_consumer_key="aaa!aaa",oauth_nonce="uTeLPs6K",oauth_signature_method="RSA-SHA256",oauth_timestamp="1524771555",oauth_version="1.0"'
      end
    end
  end
end