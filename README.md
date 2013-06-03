# Harvest

Integrate with the [Harvest API](http://www.getharvest.com/api).  Verification
is done using OAuth2 rather than HTTP Basic.  If you would like to authenticate
using HTTP Basic, check out the
[Harvested](https://github.com/zmoazeni/harvested) gem.

## Installation

Add this line to your application's Gemfile:

    gem 'harvest'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install harvest

## Usage

Create a new client by passing in a valid OAuth2 token:

```ruby
client = Harvest::Client.new('7L1pttbIrQSKC8sZpFcNhvrhlVVAQUQqB8ZPRms8GrMrnlS9hEzTVQIAv8rny/b0MFDWyZRieBdcyNEYdt2WSR==')

client.invoices
#=> [ #<Harvest::Invoice id='123456'>, #<Harvest::Invoice id='234567'> ]

invoice = client.invoices.first
#=> #<Harvest::Invoice id='123456'

invoice.id
#=> '123456'

client.invoice('234567')
#=> #<Harvest::Invoice id='234567'>

client.invoice('0')
#=> Harvest::InvoiceNotFound

invoice.amount
#=> "200.0"

client.customers
#=> [ #<Harvest::Customer>, #<Harvest::Customer> ]
```

The full list of attributes is available on the Harvest API website.  Each
attribute is accessable through a method call.  **Currently only Invoices and
Customers (Clients as Harvest refers to them) are supported.**

## Running tests

You can run all of the tests with:

    rake

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Run the tests (`rake`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request
