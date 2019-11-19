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

require 'set'

RSpec.describe Latinum::Collection do
	it "can set an initial value" do
		subject["NZD"] = BigDecimal("20")
		
		expect(subject["NZD"]).to be == Latinum::Resource.load("20 NZD")
	end
	
	it "can be negated" do
		subject["NZD"] = BigDecimal("20")
		
		negated = -subject
		
		expect(negated["NZD"]).to be == BigDecimal("-20")
	end
	
	it "should sum up currencies correctly" do
		resource = Latinum::Resource.new("10", "NZD")
		
		subject << resource
		expect(subject["NZD"]).to be == resource
		
		subject << resource
		expect(subject["NZD"]).to be == (resource * 2)
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
		
		subject = Latinum::Collection.new
		subject << resources
		
		expect(subject["NZD"]).to be == (resources[0] * 2)
		expect(subject.names).to be == Set.new(["NZD", "AUD", "USD"])
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
		
		subject << resources
		subject << other_collection
		
		expect(subject["NZD"]).to be == Latinum::Resource.load("20 NZD")
		expect(subject["AUD"]).to be == Latinum::Resource.load("20 AUD")
		expect(subject["USD"]).to be == Latinum::Resource.load("20 USD")
	end
	
	it "can enumerate resources" do
		resources = [
			Latinum::Resource.new("10", "NZD"),
			Latinum::Resource.new("10", "AUD"),
			Latinum::Resource.new("10", "USD"),
		]
		
		collection = Latinum::Collection.new
		collection << resources
		
		expect(collection.each.to_a).to be == resources
	end
	
	describe '#-@' do
		it "can subtract itself" do
			subject << Latinum::Resource.new("10.0", "NZD")
			
			result = (subject - subject).compact
			
			expect(result).to be_empty
		end
	end
	
	describe '#compact' do
		it "can remove zero value resources" do
			subject << Latinum::Resource.new("0.0", "NZD")
			
			expect(subject).to include "NZD"
			expect(subject.compact).to_not include "NZD"
		end
		
		it "doesn't remove non-zero value resources" do
			subject << Latinum::Resource.new("1.0", "NZD")
			
			expect(subject).to include "NZD"
			expect(subject.compact).to include "NZD"
		end
	end
	
	describe '#to_s' do
		it "can geneate formatted output" do
			subject << Latinum::Resource.new("5.0", "NZD")
			subject << Latinum::Resource.new("10.0", "AUD")
			subject << Latinum::Resource.new("20", "JPY")
			
			expect(subject.to_s).to be == "5.0 NZD; 10.0 AUD; 20.0 JPY"
		end
	end
end
