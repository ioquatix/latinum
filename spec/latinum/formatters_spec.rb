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

require 'latinum/bank'
require 'latinum/currencies/global'
require 'latinum/formatters'

module Latinum::FormattersSpec
	describe Latinum::Formatters::DecimalCurrencyFormatter do
		before(:all) do
			@bank = Latinum::Bank.new
			@bank.import(Latinum::Currencies::Global)
		end
		
		let(:resource) {Latinum::Resource.load("10 NZD")}
		
		it "should format output" do
			expect(@bank.format(resource)).to be == "$10.00 NZD"
		end
		
		it "should format output without name" do
			expect(@bank.format(resource, name: nil)).to be == "$10.00"
		end
		
		it "should format output with alternative name" do
			expect(@bank.format(resource, name: "Foo")).to be == "$10.00 Foo"
		end
		
		it "should format output" do
			expect(@bank.format(resource)).to be == "$10.00 NZD"
		end
		
		it "should format output without symbol" do
			expect(@bank.format(resource, symbol: nil)).to be == "10.00 NZD"
		end
		
		it "should format output with alternative symbol" do
			expect(@bank.format(resource, symbol: "!!")).to be == "!!10.00 NZD"
		end
	end
end
