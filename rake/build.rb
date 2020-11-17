# frozen_string_literal: true

# @formatter:off
# noinspection RubyBlockToMethodReference
{
  Vendorer: 'vendorer',
  CLOBBER: 'rake/clean',
  Tenjin: 'tenjin',
}.each { |k, v| autoload(k, v) }
# @formatter:on

task default: [:build]

task image.dockerfile do |task|
  image.version.to_h.merge(image: image).tap do |context|
    # @formatter:off
    Tenjin::Engine
      .new(cache: false)
      .render("#{task.name}.tpl", context)
      .tap { |output| Pathname.new(task.name).write(output) }
  end
  # @formatter:on
end

if image.respond_to?(:vendor)
  task image.vendor do |_task, args|
    # noinspection RubyLiteralArrayInspection
    ['Vendorfile.rb', 'Vendorfile'].map { |f| image.path.join(f) }.tap do |files|
      Vendorer.new(update: args.to_a.include?('update')).tap do |v|
        self.image.vendor.tap do |dir|
          v.singleton_class.__send__(:define_method, :vendor) { dir }
        end

        (files.detect(&:file?) || files.last).tap { |f| v.parse(f.read) }
      end
    end
  end

  desc 'Build image (with update)'
  task 'build:update' do
    Rake::Task[image.vendor].invoke('update')
    Rake::Task[:build].invoke
  end
end

[
  image.dockerfile,
  image.respond_to?(:vendor) ? image.vendor : nil
].compact.each do |name|
  CLOBBER.push(name.to_s)

  task 'pre_build' do
    Rake::Task[name].invoke
  end
end
