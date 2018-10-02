require 'test/unit'
require 'minitest/mock'
require_relative '../lib/oauth'

class TestGetSignatureBaseString < Test::Unit::TestCase

  def test_creates_a_correctly_constructed_and_escaped_signature_base_string

    http_method = "GET"
    base_uri = "https://sandbox.api.mastercard.com/merchantid/v1/merchantid"
    param_string = "Format=JSON&Format=XML&MerchantId=GOOGLE%20LTD%20ADWORDS%20%28CC%40GOOGLE.COM%29&Type=ExactMatch&oauth_consumer_key=aaa!aaa&oauth_nonce=uTeLPs6K&oauth_signature_method=RSA-SHA256&oauth_timestamp=1524771555&oauth_version=1.0"
    sbs = OAuth.get_signature_base_string(http_method, base_uri, param_string)

    assert_equal(sbs, "GET&https%3A%2F%2Fsandbox.api.mastercard.com%2Fmerchantid%2Fv1%2Fmerchantid&Format%3DJSON%26Format%3DXML%26MerchantId%3DGOOGLE%2520LTD%2520ADWORDS%2520%2528CC%2540GOOGLE.COM%2529%26Type%3DExactMatch%26oauth_consumer_key%3Daaa%21aaa%26oauth_nonce%3DuTeLPs6K%26oauth_signature_method%3DRSA-SHA256%26oauth_timestamp%3D1524771555%26oauth_version%3D1.0");
  end
end