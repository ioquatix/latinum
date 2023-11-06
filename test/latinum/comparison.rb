# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2015-2023, by Samuel Williams.

require 'latinum/resource'

describe Latinum::Resource do
	it "should be comparable to numeric values" do
		resource = Latinum::Resource.load("10 NZD")
		
		expect(resource).to be < 20
		expect(resource).to be > 5
		expect(resource).to be == 10
	end
	
	it "should compare with nil" do
		a = Latinum::Resource.load("10 NZD")
		
		expect{a <=> nil}.not.to raise_exception
		expect{a == nil}.not.to raise_exception
		expect(a <=> nil).to be == nil
		expect(a == nil).to be == false
	end
end
