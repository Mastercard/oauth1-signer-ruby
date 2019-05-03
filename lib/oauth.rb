require 'base64'
require 'openssl'
require 'uri'

class OAuth
  class << self

    EMPTY_STRING = ''.freeze
    SHA_BITS = '256'.freeze

    # Creates a Mastercard API compliant OAuth Authorization header
    #
    # @param {String} uri Target URI for this request
    # @param {String} method HTTP method of the request
    # @param {Any} payload Payload (nullable)
    # @param {String} consumerKey Consumer key set up in a Mastercard Developer Portal project
    # @param {String} signingKey The private key that will be used for signing the request that corresponds to the consumerKey
    # @return {String} Valid OAuth1.0a signature with a body hash when payload is present
    #
    def get_authorization_header(uri, method, payload, consumer_key, signing_key)
      query_params = extract_query_params(uri)
      oauth_params = get_oauth_params(consumer_key, payload)

      # Combine query and oauth_ parameters into lexicographically sorted string
      param_string = to_oauth_param_string(query_params, oauth_params)

      # Normalized URI without query params and fragment
      base_uri = get_base_uri_string(uri)

      # Signature base string
      sbs = get_signature_base_string(method, base_uri, param_string)

      # Signature
      signature = sign_signature_base_string(sbs, signing_key)
      oauth_params['oauth_signature'] = encode_uri_component(signature)

      # Return
      get_authorization_string(oauth_params)
    end

    #
    # Parse query parameters out of the URL.
    # https://tools.ietf.org/html/rfc5849#section-3.4.1.3
    #
    # @param {String} uri URL containing all query parameters that need to be signed
    # @return {Map<String, Set<String>} Sorted map of query parameter key/value pairs. Values for parameters with the same name are added into a list.
    #
    def extract_query_params(uri)
      query_params = URI.parse(uri).query

      return {} if query_params.eql?(nil)

      query_pairs = {}
      pairs = query_params.split('&').sort_by(&:downcase)

      pairs.each { |pair|
        idx = pair.index('=')
        key = idx > 0 ? pair[0..(idx - 1)] : pair
        query_pairs[key] = [] unless query_pairs.include?(key)
        value = if idx > 0 && pair.length > idx + 1
                  pair[(idx + 1)..pair.length]
                else
                  EMPTY_STRING
                end
        query_pairs[key].push(value)
      }
      query_pairs
    end

    #
    # @param {String} consumerKey Consumer key set up in a Mastercard Developer Portal project
    # @param {Any} payload Payload (nullable)
    # @return {Map}
    #
    def get_oauth_params(consumer_key, payload = nil)
      oauth_params = {}

      unless payload.nil?
        oauth_params['oauth_body_hash'] = get_body_hash(payload)
      end
      oauth_params['oauth_consumer_key'] = consumer_key
      oauth_params['oauth_nonce'] = get_nonce
      oauth_params['oauth_signature_method'] = "RSA-SHA#{SHA_BITS}"
      oauth_params['oauth_timestamp'] = time_stamp
      oauth_params['oauth_version'] = '1.0'

      oauth_params
    end

    #
    # Constructs a valid Authorization header as per
    # https://tools.ietf.org/html/rfc5849#section-3.5.1
    # @param {Map<String, String>} oauthParams Map of OAuth parameters to be included in the Authorization header
    # @return {String} Correctly formatted header
    #
    def get_authorization_string(oauth_params)
      header = 'OAuth '
      oauth_params.each {|entry|
        entry_key = entry[0]
        entry_val = entry[1]
        header = "#{header}#{entry_key}=\"#{entry_val}\","
      }
      # Remove trailing ,
      header.slice(0, header.length - 1)
    end

    #
    # Normalizes the URL as per
    # https://tools.ietf.org/html/rfc5849#section-3.4.1.2
    #
    # @param {String} uri URL that will be called as part of this request
    # @return {String} Normalized URL
    #
    def get_base_uri_string(uri)
      url = URI.parse(uri)
      # Lowercase scheme and authority
      # Remove query and fragment
      "#{url.scheme.downcase}://#{url.host.downcase}#{url.path}"
    end

    #
    # Lexicographically sort all parameters and concatenate them into a string as per
    # https://tools.ietf.org/html/rfc5849#section-3.4.1.3.2
    #
    # @param {Map<String, Set<String>>} queryParamsMap Map of all oauth parameters that need to be signed
    # @param {Map<String, String>} oauthParamsMap Map of OAuth parameters to be included in Authorization header
    # @return {String} Correctly encoded and sorted OAuth parameter string
    #

    def to_oauth_param_string(query_params_map, oauth_param_map)
      consolidated_params = {}.merge(query_params_map)

      # Add OAuth params to consolidated params map
      oauth_param_map.each {|entry|
        entry_key = entry[0]
        entry_val = entry[1]
        consolidated_params[entry_key] =
          if consolidated_params.include?(entry_key)
            entry_val
          else
            [].push(entry_val)
          end
      }

      oauth_params = ''

      # Add all parameters to the parameter string for signing
      consolidated_params.each do |entry|
        entry_key = entry[0]
        entry_value = entry[1]

        # Keys with same name are sorted by their values
        entry_value = entry_value.sort if entry_value.size > 1

        entry_value.each do |value|
          oauth_params += "#{entry_key}=#{value}&"
        end
      end

      # Remove trailing ampersand
      string_length = oauth_params.length - 1
      if oauth_params.end_with?('&')
        oauth_params = oauth_params.slice(0, string_length)
      end

      oauth_params
    end

    #
    # Generate a valid signature base string as per
    # https://tools.ietf.org/html/rfc5849#section-3.4.1
    #
    # @param {String} httpMethod HTTP method of the request
    # @param {String} baseUri Base URI that conforms with https://tools.ietf.org/html/rfc5849#section-3.4.1.2
    # @param {String} paramString OAuth parameter string that conforms with https://tools.ietf.org/html/rfc5849#section-3.4.1.3
    # @return {String} A correctly constructed and escaped signature base string
    #
    def get_signature_base_string(http_method, base_uri, param_string)
      sbs =
        # Uppercase HTTP method
        "#{http_method.upcase}&" +
        # Base URI
        "#{encode_uri_component(base_uri)}&" +
        # OAuth parameter string
        encode_uri_component(param_string).to_s

      sbs.gsub(/!/, '%21')
    end

    #
    # Signs the signature base string using an RSA private key. The methodology is described at
    # https://tools.ietf.org/html/rfc5849#section-3.4.3 but Mastercard uses the stronger SHA-256 algorithm
    # as a replacement for the described SHA1 which is no longer considered secure.
    #
    # @param {String} sbs Signature base string formatted as per https://tools.ietf.org/html/rfc5849#section-3.4.1
    # @param {String} signingKey Private key of the RSA key pair that was established with the service provider
    # @return {String} RSA signature matching the contents of signature base string
    #
    # noinspection RubyArgCount
    def OAuth.sign_signature_base_string(sbs, signing_key)
      digest = OpenSSL::Digest::SHA256.new
      rsa_key = OpenSSL::PKey::RSA.new signing_key

      signature = ''
      begin
        signature = rsa_key.sign(digest, sbs)
      rescue
        raise Exception, 'Unable to sign the signature base string.'
      end

      Base64.strict_encode64(signature).chomp.gsub(/\n/, '')
    end

    #
    # Generates a hash based on request payload as per
    # https://tools.ietf.org/id/draft-eaton-oauth-bodyhash-00.html
    #
    # @param {Any} payload Request payload
    # @return {String} Base64 encoded cryptographic hash of the given payload
    #
    def get_body_hash(payload)
      # Base 64 encodes the SHA1 digest of payload
      Base64.strict_encode64(Digest::SHA256.digest(payload.nil? ? '' : payload))
    end

    #
    # Encodes a text string as a valid component of a Uniform Resource Identifier (URI).
    # @ param uri_component A value representing an encoded URI component.
    #
    def encode_uri_component(uri_component)
      URI.encode_www_form_component(uri_component)
    end

    #
    # Generates a random string for replay protection as per
    # https://tools.ietf.org/html/rfc5849#section-3.3
    # @return {String} UUID with dashes removed
    #
    def get_nonce(len = 32)
      # Returns a random string of length=len
      o = [('a'..'z'), ('A'..'Z'), (0..9)].map(&:to_a).flatten
      (0...len).map { o[rand(o.length)] }.join
    end

    # Returns UNIX Timestamp as required per
    # https://tools.ietf.org/html/rfc5849#section-3.3
    # @return {String} UNIX timestamp (UTC)
    #
    def time_stamp
      Time.now.getutc.to_i
    end
  end
end
