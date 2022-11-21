# frozen_string_literal: true

# ```sh
# bundle config set --local clean 'true'
# bundle config set --local path 'vendor/bundle'
# bundle install
# ```

"#{File.dirname(__FILE__)}/dev/gems_helper.rb"
  .tap { |file| self.instance_eval(File.read(file), file, 1) }

group :default do
  github('SwagDevOps/kamaze-docker_image', { branch: 'develop' })

  gem 'kamaze-version', '~> 1.0'
  gem 'rake', '~> 13.0'
  gem 'tenjin', '~> 0.7'
end

group :development do
  github('SwagDevOps/kamaze-project', { branch: 'develop' })

  gem 'rubocop', '~> 1.3'
  gem 'rugged', '~> 1.0'
  gem 'sys-proc', '~> 1.1', '>= 1.1.2'
  # repl ---------------------------------
  gem 'interesting_methods', '~> 0.1'
  gem 'pry', '~> 0.12'
end

group :test do
  github('SwagDevOps/specinfra', { branch: 'fix/docker_finalize_container' })

  gem 'docker-api', '~> 2.0'
  gem 'rspec', '~> 3.10'
  gem 'serverspec', '~> 2.41'
end
