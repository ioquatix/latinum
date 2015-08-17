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

module Latinum
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
			raise ArgumentError.new("Cannot operate on different currencies!") if @name != other.name
			
			self.class.new(@amount + other.amount, @name)
		end
		
		def - other
			raise ArgumentError.new("Cannot operate on different currencies!") if @name != other.name
			
			self.class.new(@amount - other.amount, @name)
		end
		
		def -@
			self.class.new(-@amount, @name)
		end
		
		def * factor
			self.class.new(@amount * factor, @name)
		end
		
		def exchange(rate, name, precision = nil)
			exchanged_amount = @amount * rate
			
			exchanged_amount = exchanged_amount.round(precision) if precision
			
			self.class.new(exchanged_amount, name)
		end
		
		def to_s
			@amount.to_s('F') + ' ' + @name.to_s
		end
		
		def <=> other
			if @name == other.name
				@amount <=> other.amount
			else
				@name <=> other.name
			end
		end
		
		class << self
			def parse(string, default_name: nil)
				amount, name = string.split(/\s+/, 2)
				
				self.new(amount, name || default_name)
			end
			
			alias load parse
			
			def dump(resource)
				resource.to_s
			end
		end
		
		def zero?
			@amount.zero?
		end
	end
end
