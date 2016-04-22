# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attribute_enum/version'

Gem::Specification.new do |spec|
  spec.name          = "attribute_enum"
  spec.version       = AttributeEnum::VERSION
  spec.authors       = ["Vlad Faust"]
  spec.email         = ["vladislav.faust@gmail.com"]

  spec.summary       = 'Turns a dot-accessible class attribute to an enum (a.k.a bytefield).'
  spec.homepage      = "https://github.com/vladfaust/attribute_enum"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
