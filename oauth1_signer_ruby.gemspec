Gem::Specification.new do |gem|
  gem.name          = "oauth1_signer_ruby"
  gem.authors       = ["MasterCard API"]
  gem.summary       = %q{OAuth signature SDK}
  gem.description   = %q{This provides the base functionality to creates a Mastercard API compliant OAuth Authorization header}
  gem.version       = "1.0.0"
  gem.license       = "MIT"

  gem.files         = Dir["{bin,spec,lib}/**/*"]+ Dir["data/*"] + ["oauth1_signer_ruby.gemspec"]
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency "bundler", "~> 1.5"
  gem.add_development_dependency "rake"
end
