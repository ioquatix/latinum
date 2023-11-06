# ActiveRecord Integration

This guide explains how to use `latinum` with ActiveRecord.

## Direct Serialization

Latinum can be easily used in a [ActiveRecord](https://github.com/rails/rails/tree/master/activerecord) model simply by declaring a serialized data-type for a string or text column, e.g.

~~~ ruby
class Transaction < ActiveRecord::Base
	serialize :total, Latinum::Resource
end
~~~

It can be used like so:

~~~ ruby
transaction = Transaction.new(:total => "10 NZD")
transaction.total * 2
# => "20.0 NZD"
~~~

To format the output, use a `Latinum::Bank`, e.g. assuming the bank is set up correctly:

~~~ ruby
bank.format(transaction.total)
# => "$20.00 NZD"

bank.format(transaction.total, name: nil)
# => "$20.00"

bank.format(transaction.total, symbol: nil)
# => "20.00 NZD"
~~~

## Conversion To and From Integers

For storage in traditional databases, you may prefer to use integers. Based on the precision of the currency, you can store integer representations:

~~~ ruby
resource = Latinum::Resource.new("1.12345678", "BTC")

112345678 == bank.to_integral(resource)
# => true

resource == bank.from_integral(112345678, "BTC")
# => true
~~~

As BitCoin has 8 decimal places, it requires an integer representation with at least 10^8.
