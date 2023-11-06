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

require 'latinum'
require 'latinum/currencies/global'

describe Latinum::Bank do
	let(:bank) do
		Latinum::Bank.new.tap do |bank|
			bank.import(Latinum::Currencies::Global)
			bank << Latinum::ExchangeRate.new("NZD", "AUD", "0.5")
		end
	end
	
	it "should format the amounts correctly" do
		resource = Latinum::Resource.new("10", "NZD")
		
		expect(bank.format(resource)).to be == "$10.00 NZD"
		expect(bank.format(resource, name: nil)).to be == "$10.00"
		
		resource = Latinum::Resource.new("391", "AUD")
		expect(bank.format(resource)).to be == "$391.00 AUD"
		
		resource = Latinum::Resource.new("-100", "NZD")
		expect(bank.format(resource)).to be == "-$100.00 NZD"
		
		resource = Latinum::Resource.new("1.12345678", "BTC")
		expect(bank.format(resource)).to be == "B⃦1.12345678 BTC"
	end
	
	it "should round up using correct precision" do
		resource = Latinum::Resource.new("19.9989", "NZD")
		
		expect(bank.round(resource)).to be == Latinum::Resource.new(20, "NZD")
	end
	
	it "should round down using correct precision" do
		resource = Latinum::Resource.new("19.991", "NZD")
		
		expect(bank.round(resource)).to be == Latinum::Resource.new("19.99", "NZD")
	end
	
	it "should round values when formatting" do
		resource = Latinum::Resource.new("19.9989", "NZD")
		
		expect(bank.format(resource)).to be == "$20.00 NZD"
	end
	
	it "should exchange currencies from NZD to AUD" do
		nzd = Latinum::Resource.new("10", "NZD")
		
		aud = bank.exchange nzd, "AUD"
		expect(aud).to be == Latinum::Resource.new("5", "AUD")
	end
	
	it "should parse strings into resources" do
		expect(bank.parse("$5")).to be == Latinum::Resource.new("5", "USD")
		expect(bank.parse("$5 NZD")).to be == Latinum::Resource.new("5", "NZD")
		expect(bank.parse("€5")).to be == Latinum::Resource.new("5", "EUR")
		
		expect(bank.parse("5 NZD")).to be == Latinum::Resource.new("5", "NZD")
	
		expect(bank.parse("-$5")).to be == Latinum::Resource.new("-5", "USD")
		expect(bank.parse("-$5 NZD")).to be == Latinum::Resource.new("-5", "NZD")
		expect(bank.parse("-€5")).to be == Latinum::Resource.new("-5", "EUR")
	
		expect(bank.parse("5", default_name: "EUR")).to be == Latinum::Resource.new("5", "EUR")
		expect(bank.parse("-5", default_name: "EUR")).to be == Latinum::Resource.new("-5", "EUR")
	end
	
	it "should fail to parse unknown resource" do
		expect{bank.parse("B5")}.to raise_exception(ArgumentError)
	end
	
	with 'BRL currency' do
		it 'should be symmetric' do
			resource = Latinum::Resource.new("9.90", "BRL")
			formatted = bank.format(resource)
			expect(formatted).to be == "R$9,90 BRL"
			expect(bank.parse(formatted)).to be == resource
		end
	end
end
