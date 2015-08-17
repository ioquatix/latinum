# Latinum

Latinum is a library for resource and currency calculations. It provides immutable `Resource` objects for dealing with quantities of named resources with an arbitrary number of decimal places, and `Bank` objects for converting resources and formatting them for output. Latinum doesn't include any global state by default and thus is ideal for integration with other frameworks/libraries.

[![Build Status](https://travis-ci.org/ioquatix/latinum.svg?branch=master)](https://travis-ci.org/ioquatix/latinum)
[![Code Climate](https://codeclimate.com/github/ioquatix/latinum.png)](https://codeclimate.com/github/ioquatix/latinum)

## Installation

Add this line to your application's Gemfile:

    gem 'latinum'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install latinum

## Usage

Latinum has several core concepts:

- A `Resource` represents an immutable value with a specific face name (e.g. `'USD'`).
- A `Resource` can only be combined with resources with the same face name.
- A `Bank` is responsible for managing currencies and formatting options.
- A `Bank` can exchange currencies explicitly with a given set of exchange rates.
- A `Collection` is responsible for adding currencies together and is completely deterministic.

### Resources and Collections

To create a new resource, use a string for accuracy:

	> ten = Latinum::Resource.new("10.00", "NZD")
	=> 10.0 NZD
	> ten.amount == "10.00".to_d
	=> true

You can add resources of different values but with the same name:

	> ten + ten
	=> 20.0 NZD

But, you can't add resources of different names together:

	> twenty = Latinum::Resource.new("20.00", "AUD")
	=> 20.0 AUD
	> ten + twenty
	ArgumentError: Cannot operate on different currencies!

To add multiple currencies together, use a collection:

	> currencies = Set.new
	> collection = Latinum::Collection.new(currencies)
	> collection << [ten, twenty]
	> currencies.collect {|currency| collection[currency]}
	=> [10.0 NZD, 20.0 AUD]

### Banks and Exchange Rates

The bank is responsible for formatting and exchange rates:

	require 'latinum/bank'
	require 'latinum/currencies/global'
	
	> bank = Latinum::Bank.new(Latinum::Currencies::Global)
	> bank << Latinum::ExchangeRate.new("NZD", "AUD", "0.5")
	
	> nzd = Latinum::Resource.new("10", "NZD")
	=> 10.0 NZD
	> aud = bank.exchange nzd, "AUD"
	=> 5.0 AUD

Formatting an amount is typically required for presentation to the end user:

	> bank.format(nzd)
	=> "$10.00 NZD"
	
	> bank.format(aud, :format => :compact)
	=> "$5.00"

The bank can also be used to parse currency, which will depend on the priority of currencies if a symbol that matches multiple currencies is supplied:

	> bank.parse("$5")
	=> 5.0 USD
	
	> bank.parse("€5")
	=> 5.0 EUR

Currency codes take priority over symbols if specified:

	> bank.parse("€5 NZD")
	=> 5.0 NZD

### Conversion To and From Integers

For storage in traditional databases, you may prefer to use integers. Based on the precision of the currency, you can store integer representations:

	> resource = Latinum::Resource.new("1.12345678", "BTC")
	
	> 112345678 == bank.to_integral(resource)
	true
	
	> resource == bank.from_integral(112345678, "BTC")
	true

As BitCoin has 8 decimal places, it requires an integer representation with at least 10^8.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright, 2015, by [Samuel G. D. Williams](http://www.codeotaku.com/samuel-williams).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
