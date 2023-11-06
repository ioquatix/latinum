# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2023, by Samuel Williams.
# Copyright, 2020, by Tim Craft.

require 'latinum/resource'

module Latinum
	# A basic exchange rate for a named resource.
	class ExchangeRate
		# @parameter input [String] The name of the input resource.
		# @parameter output [String] The name of the output resource.
		# @parameter factor [Numeric] The rate of exchange.
		def initialize(input, output, factor)
			@input = input
			@output = output
			@factor = factor.to_d
		end
		
		# The name of the input resource.
		# @attribute [String]
		attr :input
		
		# The name of the output resource.
		# @attribute [String]
		attr :output
		
		# The rate of exchange.
		# @attribute [String]
		attr :factor
	end
	
	# A bank defines exchange rates and formatting rules for resources. It is a centralised location for resource formatting and metadata.
	class Bank
		# Imports all given currencies.
		def initialize
			@rates = []
			@exchange = {}
			
			# This implementation may change:
			@currencies = {}
			@formatters = {}
			
			# Symbols and their associated priorities
			@symbols = {}
		end
		
		# Import a list of resource templates, e.g. currencies.
		def import(resources)
			resources.each do |name, config|
				name = (config[:name] || name).to_s
				
				@currencies[name] = config
				
				# Create a formatter:
				@formatters[name] = config[:formatter].new(**config)
				
				if config[:symbol]
					symbols = (@symbols[config[:symbol]] ||= [])
					symbols << [config.fetch(:priority, -1), name.to_s]
					symbols.sort!.uniq!
				end
			end
		end
		
		# Look up a currency by name.
		def [](name)
			@currencies[name]
		end
		
		attr :rates
		
		# A map of all recognised symbols ordered by priority.
		# @attribute [Hash(String, Tuple(Integer, Name))]
		attr :symbols
		
		# The supported currents and assocaited formatting details.
		# @attribute [Hash(String, Hash)]
		attr :currencies
		
		# Add an exchange rate to the bank.
		# @parameter rate [ExchangeRate] The exchange rate to add.
		def <<(rate)
			@rates << rate
			
			@exchange[rate.input] ||= {}
			@exchange[rate.input][rate.output] = rate
		end
		
		# Exchange one resource for another using internally specified rates.
		def exchange(resource, for_name)
			unless rate = @exchange.dig(resource.name, for_name)
				raise ArgumentError.new("Rate #{rate} unavailable")
			end
			
			config = self[for_name]
			
			return resource.exchange(rate.factor, for_name, config[:precision])
		end
		
		# Parse a string according to the loaded currencies.
		def parse(string, default_name: nil)
			parts = string.strip.split(/\s+/, 2)
			
			if parts.size == 2
				return parse_named_resource(parts[1], parts[0])
			else
				# Lookup the named symbol, e.g. '$', and get the highest priority name:
				symbol = @symbols.fetch(string.gsub(/[\-\.,0-9]/, ''), []).last
				
				if symbol
					name = symbol.last.to_s
				elsif default_name
					name = default_name
				else
					raise ArgumentError, "Could not parse #{string}, could not determine resource name!"
				end
				
				return parse_named_resource(name, string)
			end
		end
		
		private def parse_named_resource(name, value)
			if formatter = @formatters[name]
				return Resource.new(formatter.parse(value), name)
			else
				raise ArgumentError, "No formatter found for #{name}!"
			end
		end
		
		# Rounds the specified resource to the maximum precision as specified by the formatter. Whe computing things like tax, you often get fractional amounts which are unpayable because they are smaller than the minimum discrete unit of the currency. This method helps to round a currency to a payable amount.
		# @parameter resource [Resource] The resource to round.
		# @returns [Resource] A copy of the resource with the amount rounded as per the formatter.
		def round(resource)
			unless formatter = @formatters[resource.name]
				raise ArgumentError.new("No formatter found for #{resource.name}")
			end
			
			return Resource.new(formatter.round(resource.amount), resource.name)
		end
		
		# Format a resource as a string according to the loaded currencies.
		# @parameter resource [Resource] The resource to format.
		def format(resource, *arguments, **options)
			unless formatter = @formatters[resource.name]
				raise ArgumentError.new("No formatter found for #{resource.name}")
			end
			
			formatter.format(resource.amount, *arguments, **options)
		end
		
		# Convert the resource to an integral representation based on the currency's precision.
		# @parameter resource [Resource] The resource to convert.
		# @returns [Integer] The integer representation.
		def to_integral(resource)
			formatter = @formatters[resource.name]
			
			formatter.to_integral(resource.amount)
		end
		
		# Convert the resource from an integral representation based on the currency's precision.
		# @parameter amount [Integer] The integral resource amount.
		# @parameter name [String] The resource name.
		# @returns [Resource] The converted resource.
		def from_integral(amount, name)
			formatter = @formatters[name]
			
			Resource.new(formatter.from_integral(amount), name)
		end
	end
end
