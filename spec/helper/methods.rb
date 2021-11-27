# frozen_string_literal: true

autoload(:Pathname, 'pathname')
autoload(:YAML, 'yaml')

EXPECTATIONS_PATH = Pathname.new(__dir__).join('..', 'expectations').expand_path.to_s.freeze

expectations = Class.new do
  def keys
    files.map { |f| f.basename('.*').to_s.to_sym }.freeze
  end

  # @return [Hash{Symbol => Object}]
  def items
    keys.map { |key| [key, "#{key}.yml"] }.sort.to_h.yield_self do |values|
      values.transform_values { |fp| yaml.call(fp).freeze }
    end
  end

  protected

  def path
    Pathname.new(EXPECTATIONS_PATH)
  end

  # @return [Array<Pathname>]
  def files
    Pathname.glob("#{path}/*.yml")
  end

  # @return [Proc]
  def yaml
    lambda do |fp|
      path.join(fp).read.yield_self { |c| YAML.safe_load(c) }
    end
  end
end.new

# @!method expectations()
#   Get expectations stored in ``expectations`` directory as YAML files.
#   @return [Hash{Object}]
self.singleton_class.__send__(:define_method, :expectations) do
  expectations.items
end

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
        # add expectations on spec --------------------------------------------
        klass.__send__(:define_method, :expectations) { expectations.items.fetch(self.to_sym, nil) }
      end
    end
  end
end
