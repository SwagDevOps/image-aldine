# frozen_string_literal: true

self.expectations.fetch(:packages).tap do |packages|
  # @note This spec was using ``command("/sbin/apk info -e #{package}")``
  #        with ``its(:stdout) { should match(/^#{package}$/) }``
  #        ATM it use ``be_installed`` matcher
  describe(*spec.to_a) do
    packages.each do |packager, items|
      items.each do |package|
        describe package(package) do
          it { should be_installed.by(packager) }
        end
      end
    end
  end
end
