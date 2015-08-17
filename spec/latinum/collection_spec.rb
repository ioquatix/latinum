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

module Latinum::CollectionSpec
	describe Latinum::Bank do
		before(:all) do
			@bank = Latinum::Bank.new
			@bank.import(Latinum::Currencies::Global)
		end
		
		it "should sum up currencies correctly" do
			resource = Latinum::Resource.new("10", "NZD")
			
			currencies = Set.new
			collection = Latinum::Collection.new(currencies)
			
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
				Latinum::Resource.new("10", "USD")
			]
			
			collection = Latinum::Collection.new
			collection << resources
			
			expect(collection["NZD"]).to be == (resources[0] * 2)
			expect(collection.names).to be == Set.new(["NZD", "AUD", "USD"])
		end
	end
end
