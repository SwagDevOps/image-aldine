# frozen_string_literal: true

spec.expectations.tap do |os|
  describe(*spec.to_a) do
    let(:os_version) { command('cat /etc/issue.net').stdout.strip }

    it { expect(os_version).to eq(os.fetch('version')) }
  end
end
