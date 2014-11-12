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

module Latinum
	module Formatters
		DEFAULT_OPTIONS = {
			:format => :full
		}
		
		class PlainFormatter
			def initialize(options = {})
				@name = options[:name]
			end
			
			def format(amount)
				"#{amount.to_s('F')} #{@name}"
			end
			
			def to_integral(amount)
				amount.to_i
			end
			
			def from_integral(amount)
				amount.to_d
			end
		end

		class DecimalCurrencyFormatter
			def initialize(options = {})
				@symbol = options[:symbol] || '$'
				@separator = options[:separator] || '.'
				@delimeter = options[:delimter] || ','
				@places = options[:precision] || 2
				@zero = options[:zero] || '0'

				@name = options[:name]
			end

			def format(amount, options = DEFAULT_OPTIONS)
				# Round to the desired number of places. Truncation used to be the default.
				amount = amount.round(@places)
				
				fix, frac = amount.abs.to_s('F').split(/\./, 2)

				# The sign of the number
				sign = amount.sign < 0 ? '-' : ''

				# Decimal places, e.g. the '.00' in '$10.00'
				frac = frac[0...@places].ljust(@places, @zero)

				# Grouping, e.g. the ',' in '$10,000.00'
				remainder = fix.size % 3
				groups = fix[remainder..-1].scan(/.{3}/).to_a
				groups.unshift(fix[0...remainder]) if remainder > 0

				whole = "#{sign}#{@symbol}#{groups.join(@delimeter)}"
				name = (@name && options[:format] == :full) ? " #{@name}" : ''

				if @places > 0
					"#{whole}#{@separator}#{frac}#{name}"
				else
					"#{whole}#{name}"
				end
			end
			
			def to_integral(amount)
				(amount * 10**@places).to_i
			end
			
			def from_integral(amount)
				(amount.to_d / 10**@places)
			end
		end
	end
end
