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

require 'latinum/bank'
require 'latinum/currencies/global'
require 'latinum/formatters'

describe Latinum::Formatters::PlainFormatter.new(name: "NZD") do
	let(:amount) {BigDecimal(10)}
	
	it "can convert to integral" do
		expect(subject.to_integral(amount)).to be == 10
	end
	
	it "can convert from integral" do
		expect(subject.from_integral(10)).to be == amount
	end
	
	it "can do basic formatting" do
		expect(subject.format(amount)).to be == "10.0 NZD"
	end
end

describe Latinum::Formatters::DecimalCurrencyFormatter do
	let(:bank) do
		Latinum::Bank.new.tap do |bank|
			bank.import(Latinum::Currencies::Global)
		end
	end
	
	let(:resource) {Latinum::Resource.load("10 NZD")}
	
	it "should format output" do
		expect(bank.format(resource)).to be == "$10.00 NZD"
	end
	
	it "should format output without name" do
		expect(bank.format(resource, name: nil)).to be == "$10.00"
	end
	
	it "should format output with alternative name" do
		expect(bank.format(resource, name: "Foo")).to be == "$10.00 Foo"
	end
	
	it "should format output" do
		expect(bank.format(resource)).to be == "$10.00 NZD"
	end
	
	it "should format output without symbol" do
		expect(bank.format(resource, symbol: nil)).to be == "10.00 NZD"
	end
	
	it "should format output with alternative symbol" do
		expect(bank.format(resource, symbol: "!!")).to be == "!!10.00 NZD"
	end

	it "should format output with alternative places" do
		expect(bank.format(resource, places: 4)).to be == "$10.0000 NZD"
	end
	
	with "negative zero" do
		let(:resource) {Latinum::Resource.new(BigDecimal("-0"), "NZD")}
		
		it "should format as (positve) zero" do
			expect(bank.format(resource)).to be == "$0.00 NZD"
		end
	end
end

describe Latinum::Formatters::DecimalCurrencyFormatter do
	let(:bank) do
		Latinum::Bank.new.tap do |bank|
			bank.import(Latinum::Currencies::Global)
		end
	end
	
	let(:resource) {Latinum::Resource.load("10 JPY")}
	
	it "should format without separator or fractional part" do
		expect(bank.format(resource)).to be == "¥10 JPY"
	end
end
