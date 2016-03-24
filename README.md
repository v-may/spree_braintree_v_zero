# spree_braintree_v_zero

A [Spree](http://spreecommerce.com) extension to allow payments using Braintree v.zero (DropIn) payment service.

Works with Rails 3.2.13 and Spree 1.3

Installation
------------

Add spree_braintree_v_zero to your Gemfile:

```ruby
gem 'spree_braintree_v_zero', github: 'v-may/spree_braintree_v_zero'
```

Bundle your dependencies:

```
bundle install
```

Install gem and run migrations:

    bundle exec rails g spree_braintree_v_zero:install

Restart your server

Configuration
-------------
In the admin backend go to "Configuration" -> "Payment Methods" section and then create new payment method:
  - select Spree::PaymentMethod::BraintreeVZero as a provider;
  - configure method: enter environment (sandbox/production), your merchant id, public and prevate keys.

TODO
-------------
- Add DropIn to the admin interface
- Tests


Copyright (c) 2016 [name of extension creator], released under the New BSD License
