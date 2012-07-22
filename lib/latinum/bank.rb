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

require 'latinum/resource'

module Latinum
	class ExchangeRate
		def initialize(input, output, factor)
			@input = input
			@output = output
			@factor = BigDecimal(factor)
		end
		
		attr :input
		attr :output
		attr :factor
	end
	
	class ResourceFormatter
		def format(resource)
			resource.to_s
		end
	end
	
	class DecimalCurrencyFormatter < ResourceFormatter
		def initialize(symbol, name)
			@symbol = symbol
			
			@decimal_places = 2
		end
		
		def format(resource)
			fix, frac = resource.amount.to_s('F').split(/\./, 2)
			negative = fix < 0
			
			frac_string = frac.to_s[0...2].ljust(@decimal_places, '0')
			
			fix_string = fix.to_s
			k = fix_string.size % 3
			groups = [fix_string[0...k]] + fix_string[k..-1].scan(/.{3}/).to_a
			
			"#{negative ? '-' : ''}#{@symbol}#{groups.join(',')}.#{frac}"
		end
	end
	
	class Bank
		def initialize
			@rates = []
			@exchange = {}
			
			@formatters = {}
			@symbols = {}
		end
		
		attr :rates
		attr :symbols
		attr :formatters
		
		def << object
			@rates << rate
			
			@exchange[rate.input] ||= {}
			@exchange[rate.input][rate.output] = rate
		end
		
		def []= name, formatter
			@formatters[name] = formatter
		end
		
		def exchange(resource, for_name)
			rate = @exchange[resource.name][for_name]
			raise ArgumentError.new("Invalid rate specified #{rate}") if rate == nil
			
			Resource.new(resource.amount * rate.factor, for_name)
		end
		
		def parse(string)
			parts = string.strip.split(/\s+, 2/)
			
			if parts.size == 2
				Resource.new(parts[0].gsub(/[^\.0-9]/, ''), parts[1])
			else
				name = @symbols[string.gsub(/[\-\.,0-9]/, '')]
				
				if symbol
					Resource.new(string.gsub(/[^\.0-9]/, ''), name)
				else
					raise ArgumentError.new("Could not parse #{string}")
				end
			end
		end
		
		def format(resource, options = {})
			formatter = options[:formatter] || @formatters[resource.name]
			raise ArgumentError.new("No formatter found for #{resource.name}") if formatter == nil
			
			formatter.format(resource)
		end
	end
end