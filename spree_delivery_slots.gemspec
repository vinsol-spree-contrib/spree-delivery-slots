# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_delivery_slots'
  s.version     = '3.3.0'
  s.summary     = 'It allows customer to select preferred delivery time for his order'
  s.description = 'It allows customer to select preferred delivery time for his order. Admin can add a number of time slots(ex: 11:00 AM - 3 PM and 4 PM - 9PM) when he can deliver from shipping method edit/new page. Customer will be able to select only from these pre-created time slots.'
  s.required_ruby_version = '>= 2.2.7'

  s.author    = 'Nishant Tuteja'
  s.email     = 'info@vinsol.com'
  s.homepage  = 'http://www.spreecommerce.com'

  s.files       = `git ls-files`.split("\n")
  s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '>= 3.2.0', '< 4.0'
  s.add_dependency 'spree_extension', '~> 0.0.5'

  s.add_development_dependency 'appraisal'
  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails', '~> 3.5'
  s.add_development_dependency 'shoulda-matchers', '~> 3.0'
  s.add_development_dependency 'sass-rails', '~> 5.0.0.beta1'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
