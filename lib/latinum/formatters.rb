# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2021, by Samuel Williams.
# Copyright, 2020, by Tim Craft.
# Copyright, 2021, by Adam Daniels.

module Latinum
	module Formatters
		# Formats a currency using a standard decimal notation.
		class PlainFormatter
			def initialize(name:)
				@name = name
			end
			
			# Parse a string into an amount.
			# @returns [BigDecimal] The parsed amount.
			def parse(string)
				BigDecimal(string)
			end
			
			# Formats the amount using a general notation.
			# e.g. "5.0 NZD".
			# @returns [String] The formatted string.
			def format(amount)
				"#{amount.to_s('F')} #{@name}"
			end
			
			# Converts the amount directly to an integer, truncating any decimal part.
			# @parameter amount [BigDecimal] The amount to convert to an integral.
			# @returns [Integer] The converted whole number integer.
			def to_integral(amount)
				amount.to_i
			end
			
			# Converts the amount to a decimal.
			# @parameter amount [Integer] The amount to convert to a decimal.
			# @returns [BigDecimal] The converted amount.
			def from_integral(amount)
				amount.to_d
			end
		end
		
		# Formats a currency using a standard decimal notation.
		class DecimalCurrencyFormatter
			def initialize(**options)
				@symbol = options[:symbol] || '$'
				@separator = options[:separator] || '.'
				@delimiter = options[:delimiter] || ','
				@places = options[:precision] || 2
				@zero = options[:zero] || '0'
				
				@name = options[:name]
			end
			
			def round(amount)
				return amount.round(@places)
			end
			
			# Parse a string into an amount using the configured separator and delimiter.
			# @returns [BigDecimal] The parsed amount.
			def parse(string)
				BigDecimal(
					string.gsub(/[^\-0-9#{@separator}]/, '').gsub(@separator, '.')
				)
			end
			
			# Formats the amount using the configured symbol, separator, delimiter, and places.
			# e.g. "$5,000.00 NZD". Rounds the amount to the specified number of decimal places.
			# @returns [String] The formatted string.
			def format(amount, places: @places, **options)
				# Round to the desired number of places. Truncation used to be the default.
				amount = amount.round(places).to_d
				
				integral, fraction = amount.abs.to_s('F').split(/\./, 2)
				
				# The sign of the number
				sign = '-' if amount < 0
				
				# Decimal places, e.g. the '.00' in '$10.00'
				fraction = fraction[0...places].ljust(places, @zero)
				
				# Grouping, e.g. the ',' in '$10,000.00'
				remainder = integral.size % 3
				groups = integral[remainder..-1].scan(/.{3}/).to_a
				groups.unshift(integral[0...remainder]) if remainder > 0
				
				symbol = options.fetch(:symbol, @symbol)
				value = "#{sign}#{symbol}#{groups.join(@delimiter)}"
				
				name = options.fetch(:name, @name)
				suffix = name ? " #{name}" : ''
				
				if places > 0
					"#{value}#{@separator}#{fraction}#{suffix}"
				else
					"#{value}#{suffix}"
				end
			end
			
			# Converts the amount directly to an integer, truncating any decimal part, taking into account the number of specified decimal places.
			# @parameter amount [BigDecimal] The amount to convert to an integral.
			# @returns [Integer] The converted whole number integer.
			def to_integral(amount)
				(amount * 10**@places).to_i
			end
			
			# Converts the amount to a decimal, taking into account the number of specified decimal places.
			# @parameter amount [Integer] The amount to convert to a decimal.
			# @returns [BigDecimal] The converted amount.
			def from_integral(amount)
				(amount.to_d / 10**@places)
			end
		end
	end
end
