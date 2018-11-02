require 'minitest/autorun'
require 'test/unit'
require 'minitest/mock'
require_relative '../lib/oauth'

class OAuthTest < Minitest::Test

  # Fake tests
  # Creates a valid OAuth1.0a signature with a body hash when payload is present
  def test_get_authorization_header
    uri = "HTTPS://SANDBOX.api.mastercard.com/merchantid/v1/merchantid?MerchantId=GOOGLE%20LTD%20ADWORDS%20%28CC%40GOOGLE.COM%29&Type=ExactMatch&Format=JSON"
    method = "GET"
    consumer_key = "aaa!aaa"
    signing_key = "XXX"

    OAuth.stub(:get_nonce, "uTeLPs6K") do
      OAuth.stub(:sign_signature_base_string, "XXX") do
        OAuth.stub(:time_stamp, "1524771555") do
          header = OAuth.get_authorization_header uri, method, nil, consumer_key, signing_key
          assert_equal header, "OAuth oauth_consumer_key = 'aaa!aaa',oauth_nonce = 'uTeLPs6K',oauth_signature_method = 'RSA-SHA256',oauth_timestamp = '1524771555',oauth_version = '1.0',oauth_signature = 'XXX'"
        end
      end
    end
  end
end