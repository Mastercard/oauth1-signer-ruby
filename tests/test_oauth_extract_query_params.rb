require 'minitest/autorun'
require_relative '../lib/oauth'

class TestOAuthExtractQueryParams < Minitest::Test

  @test_href = ''
  @query_params = ''

  def setup
   @test_href = "HTTPS://SANDBOX.api.mastercard.com/merchantid/v1/merchantid?MerchantId=GOOGLE%20LTD%20ADWORDS%20%28CC%40GOOGLE.COM%29&Format=XML&Type=ExactMatch&Format=JSON"
   @query_params = OAuth.extract_query_params(@test_href)
  end

  def test_should_return_a_map
    assert_equal true, (@query_params.instance_of? Hash)
  end

  def test_query_parameter_keys_should_be_sorted
    map_keys_array = @query_params.keys
    params = %w[Format MerchantId Type]
    assert_equal map_keys_array, params
  end

  def test_query_parameter_values_should_be_sorted_Values_for_parameters_with_the_same_name_are_added_into_a_list
    # Format
    values_format = @query_params['Format']
    assert_equal true, values_format.instance_of?(Array)
    assert_equal(values_format.size, 2)
    assert_equal values_format, %w[JSON XML]

    # MerchantId
    values_merchant_id = @query_params['MerchantId']
    assert_equal true, values_format.instance_of?(Array)
    assert_equal(values_merchant_id.size, 1)
    assert_equal values_merchant_id, ['GOOGLE%20LTD%20ADWORDS%20%28CC%40GOOGLE.COM%29']

    # Type
    values_type = @query_params['Type']
    assert_equal(values_type.size, 1)
    assert_equal true,  values_format.instance_of?(Array)
    assert_equal values_type, ['ExactMatch']
  end

  def test_extract_query_params_should_support_rfc_example_when_uri_created_from_uri_string
    href = 'https://example.com/request?b5=%3D%253D&a3=a&c%40=&a2=r%20b'
    params = OAuth.extract_query_params(href)

    assert_equal params['b5'], ['%3D%253D']
    assert_equal params['a3'], ['a']
    assert_equal params['c%40'], ['']
    assert_equal params['a2'], ['r%20b']
  end

  def test_extract_query_params_should_support_rfc_example_when_uri_created_from_components
    uri = URI::HTTPS.build(host: 'example.com', query: 'b5=%3D%253D&a3=a&c%40=&a2=r%20b').to_s
    params = OAuth.extract_query_params(uri)

    assert_equal params['b5'], ['%3D%253D']
    assert_equal params['a3'], ['a']
    assert_equal params['c%40'], ['']
    assert_equal params['a2'], ['r%20b']
  end

  def test_extract_query_params_should_not_encode_params_when_uri_created_from_string_with_decoded_params
    href = 'https://example.com/request?colon=:&plus=+&comma=,'
    params = OAuth.extract_query_params(href)

    assert_equal params['colon'], [':']
    assert_equal params['plus'], ['+']
    assert_equal params['comma'], [',']
  end
end