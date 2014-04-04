# Copyright, 2012, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'latinum/resource'

module Latinum
	class ExchangeRate
		def initialize(input, output, factor)
			@input = input
			@output = output
			@factor = factor.to_d
		end
		
		attr :input
		attr :output
		attr :factor
	end
	
	class Bank
		def initialize(*imports)
			@rates = []
			@exchange = {}
			
			# This implementation may change:
			@currencies = {}
			@formatters = {}
			
			# Symbols and their associated priorities
			@symbols = {}
			
			imports.each do |resources|
				import(resources)
			end
		end
		
		def import(resources)
			resources.each do |name, config|
				name = (config[:name] || name).to_s
				
				@currencies[name] = config
				
				# Create a formatter:
				@formatters[name] = config[:formatter].new(config)
				
				if config[:symbol]
					symbols = (@symbols[config[:symbol]] ||= [])
					symbols << [config.fetch(:priority, -1), name.to_s]
					symbols.sort!.uniq!
				end
			end
		end
		
		def [] name
			@currencies[name]
		end
		
		attr :rates
		attr :symbols
		attr :currencies
		
		def << rate
			@rates << rate
			
			@exchange[rate.input] ||= {}
			@exchange[rate.input][rate.output] = rate
		end
		
		def exchange(resource, for_name)
			rate = @exchange[resource.name][for_name]
			raise ArgumentError.new("Invalid rate specified #{rate}") if rate == nil
			
			config = self[for_name]
			
			resource.exchange(rate.factor, for_name, config[:precision])
		end
		
		def parse(string)
			parts = string.strip.split(/\s+/, 2)
			
			if parts.size == 2
				Resource.new(parts[0].gsub(/[^\.0-9]/, ''), parts[1])
			else
				# Lookup the named symbol, e.g. '$', and get the highest priority name:
				symbol = @symbols.fetch(string.gsub(/[\-\.,0-9]/, ''), []).last
				
				if symbol
					Resource.new(string.gsub(/[^\.0-9]/, ''), symbol.last.to_s)
				else
					raise ArgumentError.new("Could not parse #{string}, could not determine currency!")
				end
			end
		end
		
		def format(resource, *args)
			formatter = @formatters[resource.name]
			raise ArgumentError.new("No formatter found for #{resource.name}") unless formatter
			
			formatter.format(resource.amount, *args)
		end
		
		# Convert the resource to an integral representation based on the currency's precision
		def to_integral(resource)
			formatter = @formatters[resource.name]
			
			formatter.to_integral(resource.amount)
		end
		
		def from_integral(amount, resource_name)
			formatter = @formatters[resource_name]
			
			Resource.new(formatter.from_integral(amount), resource_name)
		end
	end
end
