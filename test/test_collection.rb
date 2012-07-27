
require 'helper'

require 'latinum'
require 'latinum/currencies/global'

require 'set'

class CollectionTest < Test::Unit::TestCase
	def setup
		@bank = Latinum::Bank.new
		@bank.import(Latinum::Currencies::Global)
	end
	
	def test_collections
		resource = Latinum::Resource.new("10", "NZD")
		
		currencies = Set.new
		collection = Latinum::Collection.new(currencies)
		
		collection << resource
		assert_equal resource, collection["NZD"]
		
		collection << resource
		assert_equal resource * 2, collection["NZD"]
	end
end
