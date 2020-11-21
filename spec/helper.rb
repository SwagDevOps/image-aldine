# frozen_string_literal: true

'serverspec'.tap do |gem|
  # noinspection RubyResolve
  require gem

  # noinspection RubyResolve
  if Gem::Specification.find_all_by_name('sys-proc').any?
    require 'sys/proc'

    Sys::Proc.progname = gem
  end
end

# noinspection RubyResolve
require 'rbconfig'

# @formatter:off
# noinspection RubyResolve
# noinspection RubyLiteralArrayInspection
[
  :image,
  :methods,
  :configure,
].each { |fname| require("#{__FILE__.gsub(/\.rb$/, '')}/#{fname}") }
# @formatter:on
