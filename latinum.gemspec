
require_relative "lib/latinum/version"

Gem::Specification.new do |spec|
	spec.name = "latinum"
	spec.version = Latinum::VERSION
	
	spec.summary = "Provides immutable resource and money computations."
	spec.authors = ["Samuel Williams"]
	spec.license = "MIT"
	
	spec.homepage = "https://github.com/ioquatix/latinum"
	
	spec.metadata = {
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
	}
	
	spec.files = Dir.glob('{lib}/**/*', File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 2.5"
	
	
	spec.add_development_dependency "bundler"
	spec.add_development_dependency "covered"
	spec.add_development_dependency "rake"
	spec.add_development_dependency "rspec", "~> 3.4"
end
