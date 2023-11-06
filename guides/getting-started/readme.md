# Getting Started

This guide explains how to use `latinum` for resource calculations.

## Installation

Add the gem to your project:

~~~ bash
$ bundle add latinum
~~~

## Core Concepts

Latinum has several core concepts:

- A {ruby Latinum::Resource} represents an immutable value with a specific face name (e.g. `'USD'`). It can only be combined with resources with the same face name.
- A {ruby Latinum::Bank} is responsible for managing currencies and formatting options. It can exchange currencies explicitly with a given set of exchange rates.
- A {ruby Latinum::Collection} is responsible for adding currencies together and is completely deterministic.

## Resources and Collections

To create a new resource, use a string for accuracy:

~~~ ruby
ten = Latinum::Resource.new("10.00", "NZD")
# => 10.0 NZD

ten.amount == "10.00".to_d
# => true
~~~

You can add resources of different values but with the same name:

~~~ ruby
ten + ten
# => 20.0 NZD
~~~

But, you can't add resources of different names together:

~~~ ruby
twenty = Latinum::Resource.new("20.00", "AUD")
# => 20.0 AUD

ten + twenty
# => DifferentResourceNameError: Cannot operate on different currencies!
~~~

To add multiple currencies together, use a collection:

~~~ ruby
collection = Latinum::Collection.new
collection << [ten, twenty]

collection.collect(&:to_s)
# => [10.0 NZD, 20.0 AUD]
~~~

### Calculating Totals

The `Latinum::Collection` is the correct way to sum up a list of transactions or other items with an
associated `Latinum::Resource`. Here is an example:

~~~ html
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
~~~

## Banks and Exchange Rates

The bank is responsible for formatting and exchange rates:

~~~ ruby
require 'latinum/bank'
require 'latinum/currencies/global'

bank = Latinum::Bank.new(Latinum::Currencies::Global)
bank << Latinum::ExchangeRate.new("NZD", "AUD", "0.5")

nzd = Latinum::Resource.new("10", "NZD")
# => 10.0 NZD
aud = bank.exchange nzd, "AUD"
# => 5.0 AUD
~~~

Formatting an amount is typically required for presentation to the end user:

~~~ ruby
bank.format(nzd)
# => "$10.00 NZD"

bank.format(aud, name: nil)
# => "$5.00"
~~~

The bank can also be used to parse currency, which will depend on the priority of currencies if a symbol that matches multiple currencies is supplied:

~~~ ruby
bank.parse("$5")
# => 5.0 USD

bank.parse("€5")
# => 5.0 EUR
~~~

Currency codes take priority over symbols if specified:

~~~ ruby
bank.parse("€5 NZD")
# => 5.0 NZD
~~~
