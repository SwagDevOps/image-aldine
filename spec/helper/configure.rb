# frozen_string_literal: true

# @type [Kamaze::DockerImage] image
self.image.tap do |image|
  image.id.tap do |image_id|
    raise "Can not retrieve id for image #{image.to_s.inspect} (ensure to build image fisrt)" if image_id.nil?
  end.tap do |image_id|
    RSpec.configure do |config|
      config.before(:all) do
        set(:os, family: :debian)
        set(:backend, :docker)
        set(:docker_image, image_id)
      end
    end
  end
end
