# frozen_string_literal: true

source 'https://rubygems.org'

# noinspection RubyResolve
git_source(:github) { |name| "https://github.com/#{name}.git" }

def github(repo, options = {}, &block)
  block ||= -> { gem(*[File.basename(repo)].concat([{ github: repo }.merge(options)])) }

  # noinspection RubySuperCallWithoutSuperclassInspection
  super(repo, options, &block)
end
