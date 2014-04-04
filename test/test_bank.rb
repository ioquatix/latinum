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

require 'test/unit'

require 'latinum'
require 'latinum/currencies/global'

class BankTest < Test::Unit::TestCase
	def setup
		@bank = Latinum::Bank.new
		@bank.import(Latinum::Currencies::Global)
		
		@bank << Latinum::ExchangeRate.new("NZD", "AUD", "0.5")
	end
	
	def test_formatting
		resource = Latinum::Resource.new("10", "NZD")
		assert_equal "$10.00 NZD", @bank.format(resource, :format => :full)
		assert_equal "$10.00", @bank.format(resource, :format => :compact)
		
		resource = Latinum::Resource.new("391", "AUD")
		assert_equal "$391.00 AUD", @bank.format(resource)
		
		resource = Latinum::Resource.new("-100", "NZD")
		assert_equal "-$100.00 NZD", @bank.format(resource)
		
		resource = Latinum::Resource.new("1.12345678", "BTC")
		assert_equal "B⃦1.12000000 BTC", @bank.format(resource)
	end
	
	def test_exchange
		nzd = Latinum::Resource.new("10", "NZD")
		
		aud = @bank.exchange nzd, "AUD"
		assert_equal Latinum::Resource.new("5", "AUD"), aud
	end
	
	def test_parsing
		assert_equal Latinum::Resource.new("5", "USD"), @bank.parse("$5")
		assert_equal Latinum::Resource.new("5", "NZD"), @bank.parse("$5 NZD")
		assert_equal Latinum::Resource.new("5", "EUR"), @bank.parse("€5")
		
		assert_equal Latinum::Resource.new("5", "NZD"), @bank.parse("5 NZD")
	end
end
