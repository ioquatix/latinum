
require_relative "lib/latinum/version"

Gem::Specification.new do |spec|
	spec.name          = "latinum"
	spec.version       = Latinum::VERSION
	spec.authors       = ["Samuel Williams"]
	spec.email         = ["samuel.williams@oriontransfer.co.nz"]
	spec.summary       = %q{Latinum is a simple gem for managing resource computations, including money and minerals.}
	spec.homepage      = "https://github.com/ioquatix/latinum"
	spec.license       = "MIT"
	
	spec.files         = `git ls-files`.split($/)
	spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ["lib"]
	
	spec.add_development_dependency "covered"
	spec.add_development_dependency "bundler"
	spec.add_development_dependency "rspec", "~> 3.4"
	spec.add_development_dependency "rake"
end
