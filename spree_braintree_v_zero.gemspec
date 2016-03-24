# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_braintree_v_zero'
  s.version     = '1.3.3.beta'
  s.summary     = 'Braintree v.zero support for Spree'
  s.description = 'A Spree (http://spreecommerce.com) extension to allow payments using Braintree v.zero (DropIn) payment service.'
  s.required_ruby_version = '>= 1.8.7'

  s.author    = 'Viacheslav Mayorov'
  s.email     = 'mayorovvn@gmail.com'
  s.homepage  = 'https://github.com/v-may/spree_braintree_v_zero'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 1.3.3.beta'
  s.add_dependency 'braintree'

  s.add_development_dependency 'capybara', '~> 1.1.2'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'factory_girl', '~> 2.6.4'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.9'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'sqlite3'
end
