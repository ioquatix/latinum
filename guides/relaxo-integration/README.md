# Relaxo Integration

This guide explains how to use `latinum` with [Relaxo](https://github.com/ioquatix/relaxo).

### Direct Serialization

Latinum is natively supported by Relaxo and as such can be used with [Relaxo::Model](https://github.com/ioquatix/relaxo-model) easily.

~~~ ruby
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
~~~

It gets stored in the database like so:

~~~ javascript
{
	"_id": "740f4728fc9a571d826688db2f004771",
	"_rev": "1-45a29c63311cfa0d5a765707184b2b3b",
	"type": "transaction",
	"price": [
		"50.0",
		"NZD"
	]
}
~~~
