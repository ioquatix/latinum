# encoding: utf-8
#
# Copyright (c) 2012 Samuel G. D. Williams. <http://www.oriontransfer.co.nz>
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

require 'helper'

require 'latinum'
require 'latinum/currencies/global'

require 'set'

class CollectionTest < Test::Unit::TestCase
  def setup
    @bank = Latinum::Bank.new
    @bank.import(Latinum::Currencies::Global)
  end

  def test_collections
    resource = Latinum::Resource.new("10", "NZD")

    currencies = Set.new
    collection = Latinum::Collection.new(currencies)

    collection << resource
    assert_equal resource, collection["NZD"]

    collection << resource
    assert_equal resource * 2, collection["NZD"]
  end

  def test_additions
    resources = [
                 Latinum::Resource.new("10", "NZD"),
                 Latinum::Resource.new("10", "AUD"),
                 Latinum::Resource.new("10", "USD"),
                 Latinum::Resource.new("10", "NZD"),
                 Latinum::Resource.new("10", "AUD"),
                 Latinum::Resource.new("10", "USD")
		]

    collection = Latinum::Collection.new
    collection << resources

    assert_equal resources[0] * 2, collection["NZD"]
    assert_equal Set.new(["NZD", "AUD", "USD"]), collection.names
  end
end
