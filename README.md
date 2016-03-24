# spree_braintree_v_zero

SpreeBraintreeVZero
===================

A [Spree](http://spreecommerce.com) extension to allow payments using Braintree v.zero (DropIn) payment service.

Works with Rails 3.2.13 and Spree 1.3

Installation
------------

1. Add spree_braintree_v_zero to your Gemfile:

```ruby
gem 'spree_braintree_v_zero', git: 'v-may/spree_braintree_v_zero'
```

2. Bundle your dependencies:

```
bundle install
```

3. Install gem and run migrations:

    bundle exec rails g spree_braintree_v_zero:install

4. Restart your server

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
