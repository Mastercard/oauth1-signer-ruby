Gem::Specification.new do |gem|
  gem.name          = "oauth1_signer_ruby"
  gem.authors       = ["MasterCard API"]
  gem.email         = ["APISupport@mastercard.com"]
  gem.summary       = %q{OAuth signature SDK}
  gem.description   = %q{This is the MasterCard OpenAPI. This provides the base functionality to creates a Mastercard API compliant OAuth Authorization header}

  gem.files         = Dir["{bin,spec,lib}/**/*"]+ Dir["data/*"] + ["mastercard_api_core.gemspec"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency 'simplecov', '~> 0'
end
