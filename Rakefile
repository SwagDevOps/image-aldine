# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby

require 'rubygems'
require 'bundler/setup'

if Gem::Specification.find_all_by_name('sys-proc').any?
  require 'sys/proc'

  Sys::Proc.progname = 'rake'
end

%w[env image build project].each { |req| require_relative "rake/#{req}" }
