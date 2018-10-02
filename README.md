# Table of contents
- [Overview](#overview)
  * [Compatibility](#compatibility)
  * [References](#references)
- [Usage](#usage)
  * [Prerequisites](#prerequisites)
  * [Creating a valid OAuth string](#creating-a-valid-oauth-string)

# Overview
Zero dependency library for generating a Mastercard API compliant OAuth signature.

## Compatibility
Ruby 2.5.1

## References
[OAuth 1.0a specification](https://tools.ietf.org/html/rfc5849)

[Body hash extension for non application/x-www-form-urlencoded payloads](https://tools.ietf.org/id/draft-eaton-oauth-bodyhash-00.html)

# Usage
## Prerequisites
Before using this library, you will need to set up a project and key in the [Mastercard Developers Portal](https://developer.mastercard.com). 

The two key pieces of information you will need are:

* Consumer key
* Private key matching the public key uploaded to Mastercard Developer Portal

## Creating a valid OAuth string
The method that does all the heavy lifting is `OAuth.getAuthorizationHeader`. You can call into it directly and as long as you provide the correct parameters, it will return a string that you can add into your request's `Authorization` header.

```javascript
	consumer_key = "<insert consumer key from developer portal>";
	signing_key = "<initialize private key matching the consumer key>";
	uri = "https://sandbox.api.mastercard.com/service";
	method = "GET";
	payload = "Hello world!";

	authHeader = OAuth.get_authorization_header(uri, method, payload, consumer_key, signing_key);
```
