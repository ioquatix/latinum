# Copyright, 2014, by Samuel G. D. Williams. <http://www.codeotaku.com>
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

require 'test/unit'

require 'latinum'
require 'latinum/currencies/global'

class IntegralTest < Test::Unit::TestCase
	def setup
		@bank = Latinum::Bank.new(Latinum::Currencies::Global)
	end
	
	def test_nzd_integral
		resource = Latinum::Resource.new("10", "NZD")
		
		assert_equal 1000, @bank.to_integral(resource)
		
		assert_equal resource, @bank.from_integral(1000, "NZD")
	end
	
	def test_btc_integral
		resource = Latinum::Resource.new("1.12345678", "BTC")
		
		assert_equal 112345678, @bank.to_integral(resource)
		
		assert_equal resource, @bank.from_integral(112345678, "BTC")
	end
end
