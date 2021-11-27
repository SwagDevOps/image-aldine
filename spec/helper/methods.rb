# frozen_string_literal: true

autoload(:Pathname, 'pathname')

EXPECTATIONS_PATH = Pathname.new(__dir__).join('..', 'expectations').expand_path.to_s.freeze
EXPECTATIONS_KEYS = Dir.glob("#{EXPECTATIONS_PATH}/*.yml")
                       .map { |fp| Pathname.new(fp).basename('.*').to_s.to_sym }.freeze

# @!method spec()
#   Get a description of current spec file.
#   @return [Struct]
self.singleton_class.__send__(:define_method, :spec) do
  caller_locations.first.path.yield_self do |v|
    {
      path: v,
      desc: Pathname.new(v).basename.to_s.gsub(/_spec\.rb$/, '').gsub(/[\-_]+/, ' '),
      keywords: Pathname.new(v).basename.to_s.gsub(/_spec\.rb$/, '').gsub(/[\-_]+/, ' ').split(/\s+/).map(&:to_sym)
    }.yield_self { |h| Struct.new(*h.keys).new(*h.values) }.tap do |instance|
      instance.singleton_class.tap do |klass|
        klass.__send__(:define_method, :to_a) { [desc].concat(keywords) }
        klass.__send__(:define_method, :to_s) { desc.to_s }
        klass.__send__(:define_method, :to_sym) { desc.gsub(/\s+/, '_').to_sym }
      end
    end
  end
end

# @!method expectations()
#   Get expectations stored in ``expectations`` directory as YAML files.
#   @return [Hash{Object}]
lambda do |fp|
  autoload(:YAML, 'yaml')
  Pathname.new(EXPECTATIONS_PATH).join(fp).read.yield_self { |c| YAML.safe_load(c) }
end.yield_self do |yaml|
  self.singleton_class.__send__(:define_method, :expectations) do
    EXPECTATIONS_KEYS.map { |key| [key, "#{key}.yml"] }
                     .sort
                     .to_h
                     .transform_values { |fp| yaml.call(fp).freeze }
  end
end
