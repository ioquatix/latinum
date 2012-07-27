
require 'helper'

require 'latinum'
require 'latinum/currencies/global'

class BankTest < Test::Unit::TestCase
	def setup
		@bank = Latinum::Bank.new
		@bank.import(Latinum::Currencies::Global)
		
		@bank << Latinum::ExchangeRate.new("NZD", "AUD", "0.5")
	end
	
	def test_formatting
		resource = Latinum::Resource.new("10", "NZD")
		assert_equal "$10.00 NZD", @bank.format(resource, :format => :full)
		assert_equal "$10.00", @bank.format(resource, :format => :compact)
		
		resource = Latinum::Resource.new("391", "AUD")
		assert_equal "$391.00 AUD", @bank.format(resource)
		
		resource = Latinum::Resource.new("-100", "NZD")
		assert_equal "-$100.00 NZD", @bank.format(resource)
	end
	
	def test_exchange
		nzd = Latinum::Resource.new("10", "NZD")
		
		aud = @bank.exchange nzd, "AUD"
		assert_equal Latinum::Resource.new("5", "AUD"), aud
	end
	
	def test_parsing
		assert_equal Latinum::Resource.new("5", "USD"), @bank.parse("$5")
		assert_equal Latinum::Resource.new("5", "NZD"), @bank.parse("$5 NZD")
		assert_equal Latinum::Resource.new("5", "EUR"), @bank.parse("€5")
		
		assert_equal Latinum::Resource.new("5", "NZD"), @bank.parse("5 NZD")
	end
end
