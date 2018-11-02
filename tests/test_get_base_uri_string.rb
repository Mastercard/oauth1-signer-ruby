require 'minitest/autorun'
require 'test/unit'
require 'minitest/mock'
require_relative '../lib/oauth'


class TestGetBaseUriString < Minitest::Test

  def test_creates_a_normalized_url
    href = 'https://sandbox.api.mastercard.com/merchantid/v1/merchantid?MerchantId=GOOGLE%20LTD%20ADWORDS%20%28CC%40GOOGLE.COM%29&Format=XML&Type=ExactMatch&Format=JSON'
    base_uri = OAuth.get_base_uri_string(href)

    assert_equal(base_uri, 'https://sandbox.api.mastercard.com/merchantid/v1/merchantid')
  end
end