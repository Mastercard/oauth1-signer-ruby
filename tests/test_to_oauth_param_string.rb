require 'minitest/autorun'
require 'test/unit'
require 'minitest/mock'
require_relative '../lib/oauth'

class TestToOAuthParamString < Minitest::Test

  def test_creates_a_correctly_encoded_and_sorted_OAuth_parameter_string

    consumer_key = "aaa!aaa"
    OAuth.stub(:get_nonce, "uTeLPs6K") do
      OAuth.stub(:time_stamp, "1524771555") do
        query_params = OAuth.extract_query_params'HTTPS://SANDBOX.api.mastercard.com/merchantid/v1/merchantid?MerchantId=GOOGLE%20LTD%20ADWORDS%20%28CC%40GOOGLE.COM%29&Format=XML&Type=ExactMatch&Format=JSON'
        oauth_params = OAuth.get_oauth_params consumer_key
        param_string = OAuth.to_oauth_param_string query_params, oauth_params
        assert_equal param_string, 'Format=JSON&Format=XML&MerchantId=GOOGLE%20LTD%20ADWORDS%20%28CC%40GOOGLE.COM%29&Type=ExactMatch&oauth_consumer_key=aaa!aaa&oauth_nonce=uTeLPs6K&oauth_signature_method=RSA-SHA256&oauth_timestamp=1524771555&oauth_version=1.0'
      end
    end
  end
end