# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2023, by Samuel Williams.

source 'https://rubygems.org'

gemspec

group :test do
	gem "sus"
	gem "covered"
	gem "bake-test"
	gem "bake-test-external"
end

group :maintenance, optional: true do
	gem "bake-modernize"
	gem "bake-gem"
	
	gem "utopia-project"
end
