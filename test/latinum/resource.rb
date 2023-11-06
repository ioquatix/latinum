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

require 'latinum/resource'

describe Latinum::Resource do
	it "should load and dump resources" do
		resource = Latinum::Resource.load("10 NZD")
		string_representation = Latinum::Resource.dump(resource)
		
		loaded_resource = Latinum::Resource.load(string_representation)
		
		expect(loaded_resource).to be == loaded_resource
	end
	
	it "should load and dump nil correctly" do
		expect(Latinum::Resource.load(nil)).to be == nil
		expect(Latinum::Resource.dump(nil)).to be == nil
	end
	
	it "should handle empty strings correctly" do
		expect(Latinum::Resource.load("")).to be == nil
	end
	
	it "should handle whitespace strings correctly" do
		expect(Latinum::Resource.load(" ")).to be == nil
	end
	
	it "should load and dump resources correctly" do
		resource = Latinum::Resource.new(10, 'NZD')
		
		expect(Latinum::Resource.load("10.0 NZD")).to be == resource
		expect(Latinum::Resource.dump(resource)).to be == "10.0 NZD"
	end
	
	it "should inspect nicely" do
		resource = Latinum::Resource.load("10 NZD")
		
		expect(resource.inspect).to be == '#<Latinum::Resource "10.0 NZD">'
	end
	
	it "can convert to digits" do
		resource = Latinum::Resource.load("10 NZD")
		
		expect(resource.to_digits).to be == "10.0"
	end
	
	it "should compute percentage difference" do
		original_price = Latinum::Resource.load("10 NZD")
		discount_price = Latinum::Resource.load("5 NZD")
		
		discount = (original_price - discount_price) / original_price
		
		expect(discount).to be == 0.5
	end
	
	it "should not divide" do
		original_price = Latinum::Resource.load("10 NZD")
		discount_price = Latinum::Resource.load("5 USD")
		
		expect{original_price / discount_price}.to raise_exception(Latinum::DifferentResourceNameError)
	end
	
	it "should compute quotient" do
		original_price = Latinum::Resource.load("10 NZD")
		
		expect(original_price / 2.0).to be == Latinum::Resource.load("5 NZD")
	end
	
	it "should add two resources of the same symbol" do
		a = Latinum::Resource.load("10 NZD")
		b = Latinum::Resource.load("5 NZD")
		c = Latinum::Resource.load("15 NZD")
		
		expect(a+b).to be == c
	end
	
	it "should fail two resources of different symbol" do
		a = Latinum::Resource.load("10 NZD")
		b = Latinum::Resource.load("5 USD")
		
		expect{a+b}.to raise_exception(Latinum::DifferentResourceNameError)
	end
	
	it "should be able to negate a value" do
		a = Latinum::Resource.load("10 NZD")
		b = Latinum::Resource.load("-10 NZD")
		
		expect(-a).to be == b
	end
	
	it "can be used as a hash key" do
		a = Latinum::Resource.load("10 NZD")
		b = Latinum::Resource.load("0 NZD")
		
		hash = {a => true}
		
		expect(hash).to have_keys(a)
		expect(hash).not.to have_keys(b)
	end
	
	it "can be zero" do
		a = Latinum::Resource.load("10 NZD")
		b = Latinum::Resource.load("0 NZD")
		
		expect(a).not.to be(:zero?)
		expect(b).to be(:zero?)
	end
	
	it "can be eql?" do
		a = Latinum::Resource.load("10 NZD")
		b = Latinum::Resource.load("0 NZD")
		c = Latinum::Resource.load("0 NZD")
		
		expect(a).to be(:eql?, a)
		expect(a).not.to be(:eql?, b)
		expect(b).to be(:eql?, c)
	end
end
