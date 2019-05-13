require 'minitest/autorun'
require 'test/unit'
require 'minitest/mock'
require_relative '../lib/oauth'

class TestGetSignatureBaseString < Minitest::Test

  def test_creates_a_correctly_constructed_and_escaped_signature_base_string

    http_method = "GET"
    base_uri = "https://sandbox.api.mastercard.com/merchantid/v1/merchantid"
    param_string = "Format=JSON&Format=XML&MerchantId=GOOGLE%20LTD%20ADWORDS%20%28CC%40GOOGLE.COM%29&Type=ExactMatch&oauth_consumer_key=aaa!aaa&oauth_nonce=uTeLPs6K&oauth_signature_method=RSA-SHA256&oauth_timestamp=1524771555&oauth_version=1.0"
    sbs = OAuth.get_signature_base_string(http_method, base_uri, param_string)

    assert_equal(sbs, "GET&https%3A%2F%2Fsandbox.api.mastercard.com%2Fmerchantid%2Fv1%2Fmerchantid&Format%3DJSON%26Format%3DXML%26MerchantId%3DGOOGLE%2520LTD%2520ADWORDS%2520%2528CC%2540GOOGLE.COM%2529%26Type%3DExactMatch%26oauth_consumer_key%3Daaa%21aaa%26oauth_nonce%3DuTeLPs6K%26oauth_signature_method%3DRSA-SHA256%26oauth_timestamp%3D1524771555%26oauth_version%3D1.0");
  end

  def test_creates_a_correctly_constructed_and_escaped_signature_base_string_given_encoded_params

    http_method = "GET"
    base_uri = "https://example.com/?param=token1%3Atoken2"
    consumer_key = "aaa!aaa"

    query_params = OAuth.extract_query_params'https://example.com/?param=token1%3Atoken2'
    oauth_params = OAuth.get_oauth_params consumer_key
    param_string = OAuth.to_oauth_param_string query_params, oauth_params

    sbs = OAuth.get_signature_base_string(http_method, "https://example.com", param_string)

    assert(sbs.include? "GET&https%3A%2F%2Fexample.com&param%3Dtoken1%253Atoken2");
  end

    def test_creates_a_correctly_constructed_and_escaped_signature_base_string_given_decoded_params

      http_method = "GET"
      consumer_key = "aaa!aaa"
      base_uri = "https://example.com"

      query_params = OAuth.extract_query_params'https://example.com/?param=token1:token2'
      oauth_params = OAuth.get_oauth_params consumer_key
      param_string = OAuth.to_oauth_param_string query_params, oauth_params

      sbs = OAuth.get_signature_base_string(http_method, "https://example.com", param_string)

      assert(sbs.include? "GET&https%3A%2F%2Fexample.com&param%3Dtoken1%3Atoken2");
    end

end