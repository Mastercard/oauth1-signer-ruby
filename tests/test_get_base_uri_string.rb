require 'minitest/autorun'
require 'minitest/mock'
require_relative '../lib/oauth'


class TestGetBaseUriString < Minitest::Test

  def test_creates_a_normalized_url
    href = 'https://sandbox.api.mastercard.com/merchantid/v1/merchantid?MerchantId=GOOGLE%20LTD%20ADWORDS%20%28CC%40GOOGLE.COM%29&Format=XML&Type=ExactMatch&Format=JSON'
    base_uri = OAuth.get_base_uri_string(href)
    assert_equal('https://sandbox.api.mastercard.com/merchantid/v1/merchantid', base_uri)
  end

  def test_creates_a_normalized_url_with_uppercase_path
    href = 'https://sandbox.api.mastercard.com/merchantid/v1/getMerchantId?MerchantId=GOOGLE%20LTD%20ADWORDS%20%28CC%40GOOGLE.COM%29&Format=XML&Type=ExactMatch&Format=JSON'
    base_uri = OAuth.get_base_uri_string(href)
    assert_equal('https://sandbox.api.mastercard.com/merchantid/v1/getMerchantId', base_uri)
  end

  def test_supports_rfc_examples
    href = 'https://www.example.net:8080'
    base_uri = OAuth.get_base_uri_string(href)
    assert_equal('https://www.example.net:8080/', base_uri)

    href = 'http://EXAMPLE.COM:80/r%20v/X?id=123'
    base_uri = OAuth.get_base_uri_string(href)
    assert_equal('http://example.com/r%20v/X', base_uri)
  end

  def test_removes_redundant_ports
    href = 'https://api.mastercard.com:443/test?query=param'
    base_uri = OAuth.get_base_uri_string(href)
    assert_equal('https://api.mastercard.com/test', base_uri)

    href = 'http://api.mastercard.com:80/test'
    base_uri = OAuth.get_base_uri_string(href)
    assert_equal('http://api.mastercard.com/test', base_uri)

    href = 'https://api.mastercard.com:17443/test?query=param'
    base_uri = OAuth.get_base_uri_string(href)
    assert_equal('https://api.mastercard.com:17443/test', base_uri)

    href = 'http://api.mastercard.com:1780/test?query=param'
    base_uri = OAuth.get_base_uri_string(href)
    assert_equal('http://api.mastercard.com:1780/test', base_uri)
  end

  def test_removes_fragments
    href = 'https://api.mastercard.com/test?query=param#fragment'
    base_uri = OAuth.get_base_uri_string(href)
    assert_equal('https://api.mastercard.com/test', base_uri)
  end

  def test_adds_trailing_slash
    href = 'https://api.mastercard.com'
    base_uri = OAuth.get_base_uri_string(href)
    assert_equal('https://api.mastercard.com/', base_uri)

    href = 'https://api.mastercard.com/'
    base_uri = OAuth.get_base_uri_string(href)
    assert_equal('https://api.mastercard.com/', base_uri)
  end

  def test_uses_lowercase_scheme_and_host
    href = 'HTTPS://API.MASTERCARD.COM/TEST'
    base_uri = OAuth.get_base_uri_string(href)
    assert_equal('https://api.mastercard.com/TEST', base_uri)
  end
end
