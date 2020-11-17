# frozen_string_literal: true

require 'kamaze/version'
require 'kamaze/docker_image'

autoload(:YAML, 'yaml')

Kamaze::DockerImage.new do |config|
  config.version = Kamaze::Version.new('image/version.yml').freeze
  config.path = 'image'
  config.verbose = false
  # @formatter:off
  config.ssh = nil
  config.name = [
    lambda do
      Pathname.new(__dir__).join('config/registries.yml').tap do |file|
        if !ENV['registry'].to_s.empty? and file.file?
          YAML.safe_load(file.read).tap { |h| return h.fetch(ENV['registry']) }
        end
      end

      ENV['registry']
    end.call,
    ENV.fetch('image_name'),
  ].compact.join('/')
  config.run_as = ENV.fetch('image_name').split('/').reverse
                     .concat([ENV['registry']].compact.reject(&:empty?))
                     .join('.')

  {
    stop: nil,
    start: nil,
  }.tap { |commands| config.commands.merge!(commands) }
  # @formatter:on
  config.tasks_load = !self.respond_to?(:image)
end.tap do |image|
  # noinspection RubyBlockToMethodReference
  singleton_class.__send__(:define_method, :image) { image }

  image.singleton_class.__send__(:define_method, :dockerfile) do
    Pathname.new("#{image.path}/Dockerfile")
  end

  unless ['Vendorfile.rb', 'Vendorfile'].map { |f| image.path.join(f) }.keep_if(&:file?).empty?
    image.singleton_class.__send__(:define_method, :vendor) do
      Pathname.new("#{image.path}/build/vendor")
    end
  end
end
