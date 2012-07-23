
require 'helper'

require 'latinum/bank'
require 'latinum/currencies/global'

class BankTest < Test::Unit::TestCase
	def setup
		@bank = Latinum::Bank.new
		@bank.import(Latinum::Currencies::Global)
	end
	
	def test_formatting
		resource = Latinum::Resource.new("10", "NZD")
		assert_equal "$10.00 NZD", @bank.format(resource, :format => :full)
		assert_equal "$10.00", @bank.format(resource, :format => :compact)
		
		resource = Latinum::Resource.new("391", "AUD")
		assert_equal "$391.00 AUD", @bank.format(resource)
	end
end
