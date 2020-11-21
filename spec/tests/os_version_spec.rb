# frozen_string_literal: true

describe(*spec.to_a) do
  let(:os_version) { command('cat /etc/issue.net').stdout.strip }

  it { expect(os_version).to eq('Debian GNU/Linux 10') }
end
