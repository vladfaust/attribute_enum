# AttributeEnum

Turns a dot-accessible class attribute to an enum (a.k.a bytefield).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'attribute_enum'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install attribute_enum

## Usage

Class must have read'n'write attribute named `[what's being enumerated]`.

```ruby
class Payment
  include AttributeEnum
  attr_accessor :status

  def initialize(status = 0)
    @status = status
  end

  enum :status, [ :active, :inactive ]
end

payment = Payment.new

payment.get_status # => :active
payment.inactive? # => false
payment.set_status(:inactive) # => true
payment.set_status(:invalid) # => ArgumentError('unknown value invalid')
payment.active? # => false
payment.active! # => true
payment.statuses # => [:active, :inactive]
payment.get_statuses # => [:active, :inactive]

Payment.statuses # => [:active, :inactive]
Payment.get_statuses # => [:active, :inactive]
Payment.get_status(1) # => :inactive
Payment.get_status(:active) # => 0
Payment.get_status('invalid') # => ArgumentError('valid argument is either Fixnum or Symbol')

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/vladfaust/attribute_enum. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

