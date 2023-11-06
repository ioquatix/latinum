# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2012-2021, by Samuel Williams.

require 'latinum/formatters'

module Latinum
	module Currencies
		Global = {}
		
		# @name Global[:NZD]
		# @attribute [Hash] The New Zealand Dollar configuration.
		Global[:NZD] = {
			:precision => 2,
			:symbol => '$',
			:name => 'NZD',
			:description => 'New Zealand Dollar',
			:formatter => Formatters::DecimalCurrencyFormatter,
		}
		
		# @name Global[:GBP]
		# @attribute [Hash] The Great British Pound configuration.
		Global[:GBP] = {
			:precision => 2,
			:symbol => '£',
			:name => 'GBP',
			:description => 'Pound Sterling',
			:formatter => Formatters::DecimalCurrencyFormatter,
		}
		
		# @name Global[:AUD]
		# @attribute [Hash] The Australian Dollar configuration.
		Global[:AUD] = {
			:precision => 2,
			:symbol => '$',
			:name => 'AUD',
			:description => 'Australian Dollar',
			:formatter => Formatters::DecimalCurrencyFormatter,
		}
		
		# @name Global[:USD]
		# @attribute [Hash] The United States Dollar configuration.
		Global[:USD] = {
			:precision => 2,
			:symbol => '$',
			:name => 'USD',
			:description => 'United States Dollar',
			:formatter => Formatters::DecimalCurrencyFormatter,
		}
		
		# @name Global[:EUR]
		# @attribute [Hash] The Euro configuration.
		Global[:EUR] = {
			:precision => 2,
			:symbol => '€',
			:name => 'EUR',
			:description => 'Euro',
			:formatter => Formatters::DecimalCurrencyFormatter,
			#:delimiter => '.',
			#:separator => ','
		}
		
		# @name Global[:JPY]
		# @attribute [Hash] The Japanese Yen configuration.
		Global[:JPY] = {
			:precision => 0,
			:symbol => '¥',
			:name => 'JPY',
			:description => 'Japanese Yen',
			:formatter => Formatters::DecimalCurrencyFormatter
		}
		
		# @name Global[:BRL]
		# @attribute [Hash] The Brazilian Real configuration.
		Global[:BRL] = {
			:precision => 2,
			:symbol => 'R$',
			:name => 'BRL',
			:description => 'Brazilian Real',
			:formatter => Formatters::DecimalCurrencyFormatter,
			:delimiter => '.',
			:separator => ','
		}
		
		# @name Global[:BTC]
		# @attribute [Hash] The Bitcoin configuration.
		Global[:BTC] = {
			:precision => 8,
			:symbol => 'B⃦',
			:name => 'BTC',
			:description => 'Bitcoin',
			:formatter => Formatters::DecimalCurrencyFormatter
		}
	end
end
