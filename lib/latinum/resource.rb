# frozen_string_literal: true

# Copyright, 2015, by Samuel G. D. Williams. <http://www.codeotaku.com>
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

require 'bigdecimal'
require 'bigdecimal/util'

require_relative 'error'

module Latinum
	# A Resource represents a fixed amount of a named currency or material.
	class Resource
		# Parse a string representation of a resource.
		# @parameter string [String] e.g "5 NZD".
		# @returns [Resource] The Resource that represents the parsed string.
		def self.parse(string, default_name: nil)
			amount, name = string.split(/\s+/, 2)
			
			self.new(amount, name || default_name)
		end
		
		# Load a string representation of a resource.
		# @parameter string [String | Nil] e.g. "5 NZD" or nil.
		# @returns [Resource | Nil] The Resource that represents the parsed string.
		def self.load(string)
			if string
				# Remove any whitespaces
				string = string.strip
				
				parse(string) unless string.empty?
			end
		end
		
		# Dump a string representation of a resource.
		# @parameter resource [Resource] The resource to dump.
		# @returns [String | Nil] A string that represents the {Resource}.
		def self.dump(resource)
			resource.to_s if resource
		end
		
		include Comparable
		
		def initialize(amount, name)
			@amount = amount.to_d
			@name = name
		end
		
		# The amount of the resource.
		# @attribute [BigDecimal]
		attr :amount
		
		# The name of the resource.
		# @attribute [String]
		attr :name
		
		# Add two resources. Must have the same name.
		# @returns [Resource] A resource with the added amount.
		def + other
			raise DifferentResourceNameError if @name != other.name
			
			self.class.new(@amount + other.amount, @name)
		end
		
		# Subtract two resources. Must have the same name.
		# @returns [Resource] A resource with the subtracted amount.
		def - other
			raise DifferentResourceNameError if @name != other.name
			
			self.class.new(@amount - other.amount, @name)
		end
		
		# Invert the amount of the resource.
		# @returns [Resource] A resource with the negated amount.
		def -@
			self.class.new(-@amount, @name)
		end
		
		# Multiplies the resource by a given factor.
		# @returns [Resource] A resource with the updated amount.
		def * factor
			self.class.new(@amount * factor, @name)
		end
		
		# Divides the resource by a given factor.
		# @returns [Resource] A resource with the updated amount.
		def / factor
			if factor.is_a? self.class
				raise DifferentResourceNameError if @name != factor.name
				
				@amount / factor.amount
			else
				self.class.new(@amount / factor, @name)
			end
		end
		
		# Compute a new resource using the given exchange rate for the specified name.
		# @parameter rate [Numeric] The exchange rate to use.
		# @parameter name [String] The name of the new resource.
		# @parameter precision [Integer | Nil] The number of decimal places to round to.
		def exchange(rate, name, precision = nil)
			return self if @name == name
			
			exchanged_amount = @amount * rate
			
			exchanged_amount = exchanged_amount.round(precision) if precision
			
			self.class.new(exchanged_amount, name)
		end
		
		# A human readable string representation of the resource amount and name.
		# @returns [String] e.g. "5 NZD".
		def to_s
			"#{@amount.to_s('F')} #{@name}"
		end
		
		# A human readable string representation of the resource amount.
		# @returns [String] e.g. "5.00".
		def to_digits
			@amount.to_s('F')
		end
		
		def inspect
			"#<#{self.class.name} #{self.to_s.dump}>"
		end
		
		# Compare with another {Resource} or a Numeric value.
		def <=> other
			if other.is_a? self.class
				result = @amount <=> other.amount
				return result unless result == 0
				
				result = @name <=> other.name
				return result
			elsif other.is_a? Numeric
				@amount <=> other
			end
		end
		
		def hash
			[@amount, @name].hash
		end
		
		def eql? other
			self.class.eql?(other.class) and @name.eql?(other.name) and @amount.eql?(other.amount)
		end
		
		# Whether the amount of the resource is zero.
		# @returns [Boolean]
		def zero?
			@amount.zero?
		end
	end
end
