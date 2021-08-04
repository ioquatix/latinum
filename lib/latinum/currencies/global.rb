# frozen_string_literal: true

# encoding: UTF-8
#
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
