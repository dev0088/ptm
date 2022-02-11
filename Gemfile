# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby "2.5.1"
gem "dotenv-rails", "~> 2.1", ">= 2.1.1", group: [:development, :test]
gem "activeadmin"
gem 'activeadmin_addons'
gem 'acts-as-taggable-on', '~> 6.0'
gem 'rails-jquery-autocomplete', git: 'https://github.com/risuiowa/rails-jquery-autocomplete.git'
gem 'bootstrap_tokenfield_rails'
gem "bootsnap", require: false
gem "coffee-rails", "~> 4.2"
gem "devise"
gem "draper"
gem 'elasticsearch-model'
gem 'elasticsearch-rails'
gem 'file_validators'
gem "sprockets-es6", "~> 0.9.2"
gem "babel-transpiler", "~> 0.7.0"
gem "foreman"
gem "jquery-rails"
gem 'jquery-ui-rails'
gem "local_time"
gem "mailgun_rails"
gem "paranoia", "~> 2.2"
gem "pg", ">= 0.18", "< 2.0"
gem "slim"
gem "puma", "~> 5.6"
gem "pundit"
gem "rails", "~> 5.2.1"
gem "sass-rails", "~> 5.0"
gem "aws-sdk-s3"
gem "aws-sdk-rails"
gem "sidekiq"
gem "sidekiq-scheduler", "~> 2.1.9"
gem "sidekiq-unique-jobs"
gem "simple_form"
gem "stripe"
gem "turbolinks", "~> 5"
gem "twilio-ruby", "~> 5.11.2"
gem "uglifier", ">= 1.3.0"
gem "meta-tags"
gem "easypost"
gem "name_of_person"
gem "aasm"
gem "premailer-rails"
gem "redis"
gem "city-state"
gem "ratyrate", git: 'https://github.com/azizmashkour/rails-5-ratyrate.git'
gem 'image_processing', '~> 1.2'
gem 'mini_magick'
gem 'rollbar'
gem 'money'
gem 'kaminari'
gem 'bootstrap4-kaminari-views'

gem "linkedin-oauth2", "~> 1.0"
gem 'omniauth-linkedin-oauth2'
gem 'whenever', require: false
gem 'social-share-button'
gem 'cocoon'
gem 'formtastic', '~> 3.0'

group :development, :test do
  gem "pry"
  gem "pry-rails", "~> 0.3.4"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "timecop", "~> 0.8.0"
end

group :test do
  gem "stripe-ruby-mock", "~> 2.5.5", require: "stripe_mock"
  gem "database_cleaner", "~> 1.7.0"
  gem "factory_bot_rails", "~> 4.8.2"
  gem "ffaker", "~> 2.4"
  gem "rspec-parameterized", require: false
  gem "rspec-rails", "~> 3.7.0"
  gem "rspec-retry", "~> 0.4.5"
  gem "rspec-set", "~> 0.1.3"
  gem "rspec_profiling", "~> 0.0.5"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 3.1.2", require: false
  gem "simplecov", require: false, group: :test
  gem "simplecov-json"
end

group :development do
  gem "annotate"
  gem "better_errors"
  gem "binding_of_caller"
  gem "faker"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "seed_dump"
  gem "rubocop"
  gem "rubocop-rails_config"
end
