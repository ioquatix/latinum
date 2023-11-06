# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2023, by Samuel Williams.
# Copyright, 2020, by Tim Craft.

require 'latinum'
require 'latinum/currencies/global'

describe Latinum::Bank do
	let(:bank) do
		Latinum::Bank.new(Latinum::Currencies::Global).tap do |bank|
			bank << Latinum::ExchangeRate.new("NZD", "AUD", "0.5")
		end
	end
	
	with '.load and .dump' do
		it "should load and dump resources" do
			resource = Latinum::Resource.load("10 NZD")
			string_representation = Latinum::Resource.dump(resource)
			
			loaded_resource = bank.load(string_representation)
			
			expect(loaded_resource).to be == loaded_resource
		end
		
		it "should load and dump nil correctly" do
			expect(bank.load(nil)).to be == nil
			expect(bank.dump(nil)).to be == nil
		end
		
		it "should handle empty strings correctly" do
			expect(bank.load("")).to be == nil
		end
		
		it "should handle whitespace strings correctly" do
			expect(bank.load(" ")).to be == nil
		end
		
		it "should load and dump resources correctly" do
			resource = Latinum::Resource.new(10, 'NZD')
			
			expect(bank.load("10.0 NZD")).to be == resource
			expect(bank.dump(resource)).to be == "10.0 NZD"
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
	
	with "#round" do
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
		
		it "should fail to round unknown currencies" do
			resource = Latinum::Resource.new("19.9989", "B")
			
			expect{bank.round(resource)}.to raise_exception(ArgumentError)
		end
	end
	
	with '#exchange' do
		it "should exchange currencies from NZD to AUD" do
			nzd = Latinum::Resource.new("10", "NZD")
			
			aud = bank.exchange nzd, "AUD"
			expect(aud).to be == Latinum::Resource.new("5", "AUD")
		end
		
		it "should fail to exchange currencies from NZD to unknown currency" do
			nzd = Latinum::Resource.new("10", "NZD")
			
			expect{bank.exchange(nzd, "B")}.to raise_exception(ArgumentError)
		end
	end
	
	with '#parse' do
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
			expect{bank.parse("5 B")}.to raise_exception(ArgumentError)
		end
	end
	
	it "should fail to format an unknown resource" do
		expect{bank.format(Latinum::Resource.new("5", "B"))}.to raise_exception(ArgumentError)
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
