# Copyright (c) 2012 Samuel G. D. Williams. <http://www.oriontransfer.co.nz>
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
			@amount = BigDecimal(amount)
			@name = name
		end
		
		# By default, we can only add and subtract if the name is the same
		def + other
			throw ArgumentError.new("Cannot operate on different currencies!") if @name != other.name
			
			self.class.new(@amount + other.amount, @name)
		end
		
		def - other
			throw ArgumentError.new("Cannot operate on different currencies!") if @name != other.name
			
			self.class.new(@amount - other.amount, @name)
		end
		
		def -@
			self.class.new(-@amount, @name)
		end
		
		def * factor
			self.class.new(@amount * factor, @name)
		end
		
		def to_s(options = {})
			@amount.to_s('F') + ' ' + @name.to_s
		end
		
		def <=> other
			if @name == other.name
				@amount <=> other.amount
			else
				@name <=> other.name
			end
		end
		
		def self.parse(string)
			self.new *string.split(/\s+/, 2)
		end
		
		def zero?
			@amount.zero?
		end
	end
end
