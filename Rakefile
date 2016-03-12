require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |task|
	if ENV['COVERAGE']
		begin
			require('simplecov/version')
			task.rspec_opts = %w{--require simplecov}
		rescue LoadError
		end
	end
end

task :default => :spec
