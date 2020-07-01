# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_delivery_slots'
  s.version     = '4.1'
  s.summary     = 'It allows customer to select preferred delivery time for his order'
  s.description = 'It allows customer to select preferred delivery time for his order. Admin can add a number of time slots(ex: 11:00 AM - 3 PM and 4 PM - 9PM) when he can deliver from shipping method edit/new page. Customer will be able to select only from these pre-created time slots.'
  s.required_ruby_version = '>= 2.5'

  s.author    = 'Nishant Tuteja'
  s.email     = 'info@vinsol.com'
  s.homepage  = 'http://www.spreecommerce.com'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 4.0.0'
  s.add_dependency 'spree_extension', '~> 0.0.9'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'capybara', '>= 3.30.0'
  s.add_development_dependency 'coffee-rails', '~> 5.0.0'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rails-controller-testing', '~> 1.0.4'
  s.add_development_dependency 'rspec-activemodel-mocks', '~> 1.1.0'
  s.add_development_dependency 'rspec-rails', '~> 4.0.0'
  s.add_development_dependency 'sass-rails', '>= 5.0.0'
  s.add_development_dependency 'selenium-webdriver', '~> 3.0.8'
  s.add_development_dependency 'shoulda-matchers', '~> 4.3'
  s.add_development_dependency 'shoulda-callback-matchers', '~> 1.1.1'
  s.add_development_dependency 'simplecov', '~> 0.18.0'
  s.add_development_dependency 'sqlite3', '~> 1.4'
end
