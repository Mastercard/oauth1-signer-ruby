require 'minitest/autorun'
require 'test/unit'
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
end