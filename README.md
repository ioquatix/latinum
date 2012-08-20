Latinum
=======

* Author: Samuel G. D. Williams (<http://www.oriontransfer.co.nz>)
* Copyright (C) 2012 Samuel G. D. Williams.
* Released under the MIT license.

Latinum is a framework for resource and currency calculations.

Basic Usage
-----------

Latinum has several core concepts:

- A `Resource` represents an immutable value with a specific face name (e.g. `'USD'`).
- A `Resource` can only be combined with resources with the same face name.
- A `Bank` is responsible for managing currencies and formatting options.
- A `Bank` can exchange currencies explicitly with a given set of exchange rates.
- A `Collection` is responsible for adding currencies together and is completely deterministic.

### Resources and Collections ###

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

### Banks and Exchange Rates ###

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

License
-------

Copyright (c) 2010, 2011 Samuel G. D. Williams. <http://www.oriontransfer.co.nz>

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
