Gem::Specification.new do |gem|
  gem.name          = "mastercard_oauth1_signer_ruby"
  gem.authors       = ["Mastercard"]
  gem.email         = ["APISupport@mastercard.com"]
  gem.summary       = %q{OAuth signature SDK}
  gem.description   = %q{Zero dependency library for generating a Mastercard API compliant OAuth signature}
  gem.version       = "1.0.0"
  gem.license       = "MIT"

  gem.files         = Dir["{bin,spec,lib}/**/*"]+ Dir["data/*"] + ["mastercard_oauth1_signer_ruby.gemspec"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency "bundler", "~> 1.5"
  gem.add_development_dependency "rake"
end
