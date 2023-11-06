# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2014-2023, by Samuel Williams.

require 'latinum'
require 'latinum/currencies/global'

describe Latinum::Bank do
	let(:bank) do
		Latinum::Bank.new.tap do |bank|
			bank.import(Latinum::Currencies::Global)
		end
	end
	
	it "should convert to NZD integral value" do
		resource = Latinum::Resource.new("10", "NZD")
		
		expect(bank.to_integral(resource)).to be == 1000
		
		expect(bank.from_integral(1000, "NZD")).to be == resource
	end
	
	it "should convert to BTC integral value" do
		resource = Latinum::Resource.new("1.12345678", "BTC")
		
		expect(bank.to_integral(resource)).to be == 112345678
		
		expect(bank.from_integral(112345678, "BTC")).to be == resource
	end
end
