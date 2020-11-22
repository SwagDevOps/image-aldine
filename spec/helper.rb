# frozen_string_literal: true

# Sample of execution:
#
# ```sh
# bundle exec rspec -p10 --format d
# ```

# noinspection RubyResolve
require 'rbconfig'
# noinspection RubyResolve
require 'serverspec'

ENV['progname'] ||= 'serverspec'
# noinspection RubyResolve
%w[env image methods configure]
  .each { |fname| require("#{__FILE__.gsub(/\.rb$/, '')}/#{fname}") }
