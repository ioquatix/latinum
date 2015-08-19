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
	DifferentResourceNameError: Cannot operate on different currencies!

To add multiple currencies together, use a collection:

	> currencies = Set.new
	> collection = Latinum::Collection.new(currencies)
	> collection << [ten, twenty]
	> currencies.collect {|currency| collection[currency]}
	=> [10.0 NZD, 20.0 AUD]

#### Calculating Totals

The `Latinum::Collection` is the correct way to sum up a list of transactions or other items with an
associated `Latinum::Resource`. Here is an example:

	<table class="listing transactions" data-model="Transaction">
		<thead>
			<tr>
				<th class="name">Name</th>
				<th class="date">Date</th>
				<th class="price">Price</th>
				<th class="quantity">Quantity</th>
				<th class="subtotal">Sub-total</th>
				<th class="tax_rate">Tax</th>
				<th class="total">Total</th>
			</tr>
		</thead>
		<tbody>
			<?r 
				currencies = Set.new
				
				summary = {
					:subtotal => Latinum::Collection.new(currencies),
					:tax => Latinum::Collection.new(currencies),
					:total => Latinum::Collection.new(currencies)
				}
				
				invoice.transactions.each do |transaction|
					subtotal = transaction.subtotal
					summary[:subtotal] << subtotal
					summary[:tax] << subtotal * transaction.tax_rate.to_d
					summary[:total] << transaction.total
				
			?>
			<tr data-id="#{transaction.id}" data-rev="#{transaction.rev}">
				<th class="name">#{f.text transaction.name}</th>
				<td class="date">#{f.text transaction.date}</td>
				<td class="price">#{f.text transaction.price}</td>
				<td class="quantity">#{f.quantity transaction}</td>
				<td class="subtotal">#{f.text subtotal}</td>
				<td class="tax_rate">#{f.tax transaction}</td>
				<td class="total">#{f.text transaction.total}</td>
			</tr>
			<?r end ?>
		</tbody>
		<tfoot>
			<?r currencies.each do |currency| ?>
			<tr>
				<td colspan="5">#{currency} Summary:</td>
				<td class="subtotal">#{f.text summary[:subtotal][currency]}</td>
				<td class="tax_rate">#{f.text summary[:tax][currency]}</td>
				<td class="total">#{f.text summary[:total][currency]}</td>
				<td></td>
			</tr>
			<?r end ?>
		</tfoot>
	</table>

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

### ActiveRecord Serialization

Latinum can be easily used in a [ActiveRecord](https://github.com/rails/rails/tree/master/activerecord) model simply by declaring a serialized data-type for a string or text column, e.g.

	class Transaction < ActiveRecord::Base
		serialize :total, Latinum::Resource
	end

It can be used like so:

	> transaction = Transaction.new(:total => "10 NZD")
	> transaction.total * 2
	=> "20.0 NZD"

To format the output, use a `Latinum::Bank`, e.g. assuming the bank is set up correctly:

	> bank.format(transaction.total)
	=> "$20.00 NZD"
	
	> bank.format(transaction.total, name: nil)
	=> "$20.00"
	
	> bank.format(transaction.total, symbol: nil)
	=> "20.00 NZD"

### Relaxo Serialization

Latinum is natively supported by [Relaxo](https://github.com/ioquatix/relaxo) (CouchDB) and as such can be used in [Relaxo models](https://github.com/ioquatix/relaxo-model) easily.

	require 'latinum'
	require 'relaxo/model'
	require 'relaxo/model/properties/latinum'
	
	class Transaction
		include Relaxo::Model

		property :name
		property :price, Attribute[Latinum::Resource]
	end
	
	db = Relaxo.connect('test')
	db.create!
	
	t = Transaction.create(db, price: Latinum::Resource.load("50 NZD"))
	
	t.price
	# => <Latinum::Resource "50.0 NZD">
	
	# Save and reload from database server:
	t.save
	t = Transaction.fetch(db, t.id)
	
	t.price
	# => <Latinum::Resource "50.0 NZD">

It gets stored in the database like so:

	{
		"_id": "740f4728fc9a571d826688db2f004771",
		"_rev": "1-45a29c63311cfa0d5a765707184b2b3b",
		"type": "transaction",
		"price": [
			"50.0",
			"NZD"
		]
	}

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
