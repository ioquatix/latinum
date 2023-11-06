# ActiveRecord Integration

This guide explains how to use `latinum` with ActiveRecord.

## Direct Serialization

Latinum can be easily used in a [ActiveRecord](https://github.com/rails/rails/tree/master/activerecord) model simply by declaring a serialized data-type for a string or text column, e.g.

~~~ ruby
class Transaction < ActiveRecord::Base
	serialize :total, coder: Latinum::Resource
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

## Bank Serialization

If you want to accept ambiguous input, e.g. `$5` and have the bank determine the currency, you can use the `Latinum::Bank` as the serializer:

~~~ ruby
require 'latinum/bank'
require 'latinum/currencies/global'

class Transaction < ActiveRecord::Base
	BANK = Latinum::Bank.new(Latinum::Currency::Global)

	serialize :total, coder: BANK
end
~~~

This will store the same format as the `Latinum::Resource` serializer, but will allow you to use the bank to determine the currency. When several symbols share the same prefix (e.g. `$`), the bank will choose the currency with the highest priority.

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
