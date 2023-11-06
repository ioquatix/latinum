# frozen_string_literal: true

require_relative "lib/latinum/version"

Gem::Specification.new do |spec|
	spec.name = "latinum"
	spec.version = Latinum::VERSION
	
	spec.summary = "Provides immutable resource and money computations."
	spec.authors = ["Samuel Williams", "Tim Craft", "Adam Daniels", "Michael Adams"]
	spec.license = "MIT"
	
	spec.cert_chain  = ['release.cert']
	spec.signing_key = File.expand_path('~/.gem/release.pem')
	
	spec.homepage = "https://github.com/ioquatix/latinum"
	
	spec.metadata = {
		"funding_uri" => "https://github.com/sponsors/ioquatix/",
	}
	
	spec.files = Dir.glob(['{lib}/**/*', '*.md'], File::FNM_DOTMATCH, base: __dir__)
	
	spec.required_ruby_version = ">= 3.0"
end
