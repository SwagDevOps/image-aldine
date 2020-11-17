# frozen_string_literal: true

# ```sh
# bundle config set clean 'true'
# bundle config set path 'vendor/bundle'
# bundle install
# ```
source 'https://rubygems.org'
git_source(:github) { |name| "https://github.com/#{name}.git" }

group :default do
  { github: 'SwagDevOps/kamaze-docker_image', branch: 'develop' }.tap do |options|
    gem(*['kamaze-docker_image'].concat([options]))
  end

  gem 'kamaze-version', '~> 1.0'
  gem 'rake', '~> 13.0'
  gem 'tenjin', '~> 0.7'
end

group :development do
  { github: 'SwagDevOps/kamaze-project', branch: 'develop' }.tap do |options|
    gem(*['kamaze-project'].concat([options]))
  end

  gem 'rubocop', '~> 1.3'
  gem 'sys-proc', '~> 1.1', '>= 1.1.2'
  # repl ---------------------------------
  gem 'interesting_methods', '~> 0.1'
  gem 'pry', '~> 0.12'
end

group :test do
  gem 'excon', '~> 0.78', '>= 0.71.0'
  gem 'rspec', '~> 3.10'
  gem 'serverspec', '~> 2.41'
end
