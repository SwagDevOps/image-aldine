# frozen_string_literal: true

# Dotfile from dist ---------------------------------------------------
lambda do
  autoload(:Pathname, 'pathname')
  {
    dist: Pathname.new(Dir.pwd).join('.env.dist'),
    real: Pathname.new(Dir.pwd).join('.env'),
  }.tap do |files|
    files.fetch(:dist).read.tap do |content|
      files.fetch(:real).write(content) unless files.fetch(:real).exist?
    end
  end
end.call

# Load dotenv file ----------------------------------------------------
lambda do
  autoload(:Dotenv, 'dotenv')
  Dotenv
end.call.load

# Set progname --------------------------------------------------------
lambda do
  if Gem::Specification.find_all_by_name('sys-proc').any?
    require 'sys/proc'

    Sys::Proc.progname = ENV.fetch('progname', 'rake')
  end
end.call
