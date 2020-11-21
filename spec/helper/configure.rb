# frozen_string_literal: true

# @type [Kamaze::DockerImage] image
self.image.tap do |image|
  RSpec.configure do |config|
    config.before(:all) do
      set(:os, family: :debian)
      set(:backend, :docker)
      set(:docker_image, image.id)
    end
  end
end
