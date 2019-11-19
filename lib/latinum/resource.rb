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

module Latinum
	class DifferentResourceNameError < ArgumentError
		def initialize
			super "Cannot operate on different currencies!"
		end
	end
	
	# A fixed unit in a given named resource
	class Resource
		include Comparable
		
		attr :amount
		attr :name
		
		def initialize(amount, name)
			@amount = amount.to_d
			@name = name
		end
		
		# By default, we can only add and subtract if the name is the same
		def + other
			raise DifferentResourceNameError if @name != other.name
			
			self.class.new(@amount + other.amount, @name)
		end
		
		def - other
			raise DifferentResourceNameError if @name != other.name
			
			self.class.new(@amount - other.amount, @name)
		end
		
		def -@
			self.class.new(-@amount, @name)
		end
		
		def * factor
			self.class.new(@amount * factor, @name)
		end
		
		def / factor
			if factor.is_a? self.class
				raise DifferentResourceNameError if @name != factor.name
				
				@amount / factor.amount
			else
				self.class.new(@amount / factor, @name)
			end
		end
		
		def exchange(rate, name, precision = nil)
			return self if @name == name
			
			exchanged_amount = @amount * rate
			
			exchanged_amount = exchanged_amount.round(precision) if precision
			
			self.class.new(exchanged_amount, name)
		end
		
		def to_s
			"#{@amount.to_s('F')} #{@name}"
		end
		
		def inspect
			"#<#{self.class.name} #{self.to_s.dump}>"
		end
		
		# Compare with another resource or a Numeric value.
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
			self.class.eql? other.class and @name.eql? other.name and @amount.eql? other.amount
		end
		
		class << self
			def parse(string, default_name: nil)
				amount, name = string.split(/\s+/, 2)
				
				self.new(amount, name || default_name)
			end
			
			def load(string)
				if string
					# Remove any whitespaces
					string = string.strip
					
					parse(string) unless string.empty?
				end
			end
			
			def dump(resource)
				resource.to_s if resource
			end
		end
		
		def zero?
			@amount.zero?
		end
	end
end
