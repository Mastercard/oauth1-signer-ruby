# oauth1-signer-ruby

[![](https://travis-ci.org/Mastercard/oauth1-signer-ruby.svg?branch=master)](https://travis-ci.org/Mastercard/oauth1-signer-ruby)
[![](https://sonarcloud.io/api/project_badges/measure?project=Mastercard_oauth1-signer-ruby&metric=alert_status)](https://sonarcloud.io/dashboard?id=Mastercard_oauth1-signer-ruby) 
[![](https://img.shields.io/gem/v/mastercard_oauth1_signer.svg)](https://rubygems.org/gems/mastercard_oauth1_signer)
[![](https://img.shields.io/badge/license-MIT-yellow.svg)](https://github.com/Mastercard/oauth1-signer-ruby/blob/master/LICENSE)


## Table of Contents
- [Overview](#overview)
  * [Compatibility](#compatibility)
  * [References](#references)
- [Usage](#usage)
  * [Prerequisites](#prerequisites)
  * [Adding the Library to Your Project](#adding-the-library-to-your-project)
  * [Loading the Signing Key](#loading-the-signing-key) 
  * [Creating the OAuth Authorization Header](#creating-the-oauth-authorization-header)
  * [Integrating with OpenAPI Generator API Client Libraries](#integrating-with-openapi-generator-api-client-libraries)

## Overview <a name="overview"></a>
Zero dependency library for generating a Mastercard API compliant OAuth signature.

### Compatibility <a name="compatibility"></a>
* Ruby 2.4.4+
* Truffle Ruby 1.0.0+

### References <a name="references"></a>
* [OAuth 1.0a specification](https://tools.ietf.org/html/rfc5849)
* [Body hash extension for non application/x-www-form-urlencoded payloads](https://tools.ietf.org/id/draft-eaton-oauth-bodyhash-00.html)

## Usage <a name="usage"></a>
### Prerequisites <a name="prerequisites"></a>
Before using this library, you will need to set up a project in the [Mastercard Developers Portal](https://developer.mastercard.com). 

As part of this set up, you'll receive credentials for your app:
* A consumer key (displayed on the Mastercard Developer Portal)
* A private request signing key (matching the public certificate displayed on the Mastercard Developer Portal)

### Adding the Library to Your Project <a name="adding-the-library-to-your-project"></a>

```shell
gem install mastercard_oauth1_signer.gem
```

### Loading the Signing Key <a name="loading-the-signing-key"></a>

The following code shows how to load the private key using `OpenSSL`:
```ruby
is = File.binread ("<insert PKCS#12 key file path>");
signing_key = OpenSSL::PKCS12.new (is, "<insert key password>").key;
```

### Creating the OAuth Authorization Header
The method that does all the heavy lifting is `OAuth.get_authorization_header`. You can call into it directly and as long as you provide the correct parameters, it will return a string that you can add into your request's `Authorization` header.

```ruby
consumer_key = "<insert consumer key>";
uri = "https://sandbox.api.mastercard.com/service";
method = "POST";
payload = "Hello world!";
authHeader = OAuth.get_authorization_header(uri, method, payload, consumer_key, signing_key);
```

### Integrating with OpenAPI Generator API Client Libraries <a name="integrating-with-openapi-generator-api-client-libraries"></a>

[OpenAPI Generator](https://github.com/OpenAPITools/openapi-generator) generates API client libraries from [OpenAPI Specs](https://github.com/OAI/OpenAPI-Specification). 
It provides generators and library templates for supporting multiple languages and frameworks.

Generators currently supported:
+ [ruby](#ruby)

#### ruby <a name="ruby"></a>

##### OpenAPI Generator

Client libraries can be generated using the following command:
```shell
java -jar openapi-generator-cli.jar generate -i openapi-spec.yaml -g ruby -o out
```
See also: 
* [OpenAPI Generator (executable)](https://mvnrepository.com/artifact/org.openapitools/openapi-generator-cli)
* [CONFIG OPTIONS for ruby](https://github.com/OpenAPITools/openapi-generator/blob/master/docs/generators/ruby.md)

##### Callback method `Typhoeus.before`

The Authorization header can be hooked into before a request run: 

```ruby
config = OpenapiClient::Configuration.default
api_client = OpenapiClient::ApiClient.new
config.basePath = "https://sandbox.api.mastercard.com"
api_client.config = config

Typhoeus.before { |request|
  authHeader =
      OAuth.get_authorization_header request.base_url, request.options[:method],
                                     request.options[:body], consumer_key, signing_key.key
  request.options[:headers] = request.options[:headers].merge({'Authorization' => authHeader})
}
    
serviceApi = service.ServiceApi.new api_client

opts = {}
serviceApi.call opts
// ...
```

See also: https://www.rubydoc.info/github/typhoeus/typhoeus/Typhoeus.before
