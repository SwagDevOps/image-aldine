# frozen_string_literal: true

spec.expectations.sort.map { |k, v| [k.to_s.freeze, v.to_s.freeze] }.to_h.freeze.tap do |expectations|
  describe(*spec.to_a) do
    # Produce an extract of shell variables values limited to searched varaibles (indexes).
    #
    # Empty values are nullified.
    let(:env) do
      {}.tap do |env|
        [].tap do |threads|
          expectations.each_key do |k|
            threads << Thread.new do
              Thread.current.abort_on_exception = true
              env[k] = command("echo $#{k}").stdout.chomp
            end
          end
        end.map(&:join)
      end.transform_values { |v| v.to_s.empty? ? nil : v }
    end

    it { expect(env).to eq(expectations) }
  end
end
