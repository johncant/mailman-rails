# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mailman-rails/version'

Gem::Specification.new do |gem|
  gem.name          = "mailman-rails"
  gem.version       = Mailman::Rails::VERSION
  gem.authors       = ["John Cant"]
  gem.email         = ["a.johncant@gmail.com"]
  gem.description   = %q{Ease Mailman integration with Rails}
  gem.summary       = %q{Ease Mailman integration with Rails}
  gem.homepage      = "https://github.com/johncant/mailman-rails"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "mailman"
  gem.add_development_dependency "rspec"
end
