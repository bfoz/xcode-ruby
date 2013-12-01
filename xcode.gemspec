# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "xcode"
  spec.version       = '0.1'
  spec.authors       = ["Brandon Fosdick"]
  spec.email         = ["bfoz@bfoz.net"]
  spec.description   = %q{Xcode project and template tools}
  spec.summary       = %q{Everything needed to read, write and manipulate Xcode project and template files}
  spec.homepage      = "http://github.com/bfoz/xcode-ruby"
  spec.license       = "BSD"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
