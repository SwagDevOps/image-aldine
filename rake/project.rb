# frozen_string_literal: true

if Gem::Specification.find_all_by_name('kamaze-project').any?
  require 'kamaze/project'

  self.tap do |main|
    Kamaze.project do |project|
      project.subject = Class.new { const_set(:VERSION, main.image.version) }
      project.name    = image.name
      # noinspection RubyLiteralArrayInspection
      project.tasks   = [
        'cs:correct', 'cs:control', 'cs:pre-commit',
        'misc:gitignore',
        'shell',
        'test',
        'version:edit',
      ]
    end.load!
  end
end
