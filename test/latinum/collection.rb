# frozen_string_literal: true

# Copyright, 2015, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, collection to the following conditions:
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

require 'set'

describe Latinum::Collection do
	let(:collection) {subject.new}
	
	it "can set an initial value" do
		collection["NZD"] = BigDecimal("20")
		
		expect(collection["NZD"]).to be == Latinum::Resource.load("20 NZD")
	end
	
	it "can be negated" do
		collection["NZD"] = BigDecimal("20")
		
		negated = -collection
		
		expect(negated["NZD"]).to be == BigDecimal("-20")
	end
	
	it "should sum up currencies correctly" do
		resource = Latinum::Resource.new("10", "NZD")
		
		collection << resource
		expect(collection["NZD"]).to be == resource
		
		collection << resource
		expect(collection["NZD"]).to be == (resource * 2)
	end
	
	it "should sum up multiple currencies correctly" do
		resources = [
			Latinum::Resource.new("10", "NZD"),
			Latinum::Resource.new("10", "AUD"),
			Latinum::Resource.new("10", "USD"),
			Latinum::Resource.new("10", "NZD"),
			Latinum::Resource.new("10", "AUD"),
			Latinum::Resource.new("10", "USD"),
		]
		
		collection = Latinum::Collection.new
		collection << resources
		
		expect(collection["NZD"]).to be == (resources[0] * 2)
		expect(collection.names).to be == Set.new(["NZD", "AUD", "USD"])
	end
	
	it "can add two collections together" do
		other_resources = [
			Latinum::Resource.new("10", "NZD"),
			Latinum::Resource.new("10", "AUD"),
			Latinum::Resource.new("10", "USD"),
		]
		
		other_collection = Latinum::Collection.new
		other_collection << other_resources
		
		resources = [
			Latinum::Resource.new("10", "NZD"),
			Latinum::Resource.new("10", "AUD"),
			Latinum::Resource.new("10", "USD"),
		]
		
		collection << resources
		collection << other_collection
		
		expect(collection["NZD"]).to be == Latinum::Resource.load("20 NZD")
		expect(collection["AUD"]).to be == Latinum::Resource.load("20 AUD")
		expect(collection["USD"]).to be == Latinum::Resource.load("20 USD")
	end
	
	it "can enumerate resources" do
		resources = [
			Latinum::Resource.new("10", "NZD"),
			Latinum::Resource.new("10", "AUD"),
			Latinum::Resource.new("10", "USD"),
		]
		
		collection << resources
		
		expect(collection.each.to_a).to be == resources
	end
	
	with '#-@' do
		it "can subtract itself" do
			collection << Latinum::Resource.new("10.0", "NZD")
			
			result = (collection - collection).compact
			
			expect(result).to be(:empty?)
		end
	end
	
	with '#compact' do
		it "can remove zero value resources" do
			collection << Latinum::Resource.new("0.0", "NZD")
			
			expect(collection).to have_keys("NZD")
			expect(collection.compact).not.to have_keys("NZD")
		end
		
		it "doesn't remove non-zero value resources" do
			collection << Latinum::Resource.new("1.0", "NZD")
			
			expect(collection).to have_keys("NZD")
			expect(collection.compact).to have_keys("NZD")
		end
	end
	
	with '#to_s' do
		it "can geneate formatted output" do
			collection << Latinum::Resource.new("5.0", "NZD")
			collection << Latinum::Resource.new("10.0", "AUD")
			collection << Latinum::Resource.new("20", "JPY")
			
			expect(collection.to_s).to be == "5.0 NZD; 10.0 AUD; 20.0 JPY"
		end
	end
end
