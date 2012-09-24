# Harvest

Integrate with the [Harvest API](http://www.getharvest.com/api).  Verification is done using OAuth2 rather than HTTP Basic.  If you would like to authenticate using HTTP Basic, check out the [Harvested](https://github.com/zmoazeni/harvested) gem.

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
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
