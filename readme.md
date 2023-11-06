# Latinum

Latinum is a library for resource and money calculations. It provides immutable {ruby Latinum::Resource} objects for dealing with quantities of named resources with an arbitrary number of decimal places, and {ruby Latinum::Bank} objects for converting resources and formatting them for output. Latinum doesn't include any global state by design and thus is ideal for integration with other frameworks/libraries.

[![Development Status](https://github.com/ioquatix/latinum/workflows/Test/badge.svg)](https://github.com/ioquatix/latinum/actions?workflow=Test)

## Motivation

I was originally planning on using the [Money gem](https://github.com/RubyMoney/money), but it's [dependency on global state](https://github.com/RubyMoney/money/blob/39b617cca8f02c885cc8246e0aab3e9dc5f90e15/lib/money/currency.rb#L19-L21) makes it hard to use if you want to deal with money as an immutable value type.

Additionally, I wanted to support BitCoin, Japanese Yen, etc. The money gem was heavily biased towards decimal currency. It had (\~2012) [fields like `dollars` and `cents`](https://github.com/RubyMoney/money/issues/197) which don't really make sense and don't really align with the real world. These days they have fixed parts of the API, but it's a bit of a mess now, supporting both decimal and non-decimal values.

Another problem I had at the time was the [concept of zero](https://github.com/RubyMoney/money/issues/195). It should be possible to have an additive (e.g. 0) and multiplicative identity (e.g. 1) do the right thing. In fact, in Latinum, you can multiply `Latinum::Resource` instances by a scalar and get a useful result (e.g. for computing discounts).

Finally, because of the above problem, it was not obvious at the time how to sum up a collection of money instances correctly. In fact, this is still a problem and a separate gem, based on the `Latinum::Collection` concept, [was made](https://github.com/lulalala/money-collection). However, this all fits together in a rather haphazard way.

Latinum addresses all these issues. It has an immutable value type `Latinum::Resource` which has a robust definition: A value (e.g. 5.0025) and a resource name (USD). The semantics of resources are well defined without the need for "Currency" state like the symbol, how many decimal places, etc. So, it suits well for serialization into a database, and for formatting to the user, there is `Latinum::Bank` which gives you the choice of how you decide to format things or exchange them, whether you want to round something off, etc.

## Usage

Please see the [project documentation](https://ioquatix.github.io/latinum).

## Contributing

We welcome contributions to this project.

1.  Fork it.
2.  Create your feature branch (`git checkout -b my-new-feature`).
3.  Commit your changes (`git commit -am 'Add some feature'`).
4.  Push to the branch (`git push origin my-new-feature`).
5.  Create new Pull Request.

### Developer Certificate of Origin

This project uses the [Developer Certificate of Origin](https://developercertificate.org/). All contributors to this project must agree to this document to have their contributions accepted.

### Contributor Covenant

This project is governed by [Contributor Covenant](https://www.contributor-covenant.org/). All contributors and participants agree to abide by its terms.
