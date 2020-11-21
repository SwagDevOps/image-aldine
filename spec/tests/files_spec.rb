# frozen_string_literal: true

# COPY files/ /
self.expectations.fetch(spec.to_sym).tap do |files|
  describe(*spec.to_a) do
    files.each do |fp, expectations|
      describe file(fp) do
        expectations['is'].to_a.each do |word, args|
          it { should public_send("be_#{word}", *args.to_a) }
        end

        expectations['md5sum']&.tap do |md5sum|
          its(:md5sum) { should eq md5sum }
        end
      end
    end
  end
end
