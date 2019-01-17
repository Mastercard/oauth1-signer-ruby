# oauth1-signer-ruby

[![Build Status](https://travis-ci.org/Mastercard/oauth1-signer-ruby.svg?branch=master)](https://travis-ci.org/Mastercard/oauth1-signer-ruby)
[![RubyGems](https://img.shields.io/gem/v/mastercard_oauth1_signer.svg)](https://rubygems.org/gems/mastercard_oauth1_signer)
[![License: MIT](https://img.shields.io/badge/license-MIT-yellow.svg)](https://github.com/Mastercard/oauth1-signer-ruby/blob/master/LICENSE)


## Table of Contents
- [Overview](#overview)
  * [Compatibility](#compatibility)
  * [References](#references)
- [Usage](#usage)
  * [Prerequisites](#prerequisites)
  * [Adding the Library to Your Project](#adding-the-library-to-your-project)
  * [Creating the OAuth Authorization Header](#creating-the-oauth-authorization-header)

## Overview <a name="overview"></a>
Zero dependency library for generating a Mastercard API compliant OAuth signature.

### Compatibility <a name="compatibility"></a>
* Ruby [2.5.1+](https://www.ruby-lang.org/en/news/2018/03/28/ruby-2-5-1-released/)
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

```
gem install mastercard_oauth1_signer_ruby
```

### Creating the OAuth Authorization Header
The method that does all the heavy lifting is `OAuth.get_authorization_header`. You can call into it directly and as long as you provide the correct parameters, it will return a string that you can add into your request's `Authorization` header.

```ruby
consumer_key = "<insert consumer key>";
is = File.binread ("<insert PKCS#12 key file path>");
signing_key = OpenSSL::PKCS12.new (is, "<insert key password>").key;
 
uri = "https://sandbox.api.mastercard.com/service";
method = "POST";
payload = "Hello world!";

authHeader = OAuth.get_authorization_header(uri, method, payload, consumer_key, signing_key);
```
