#!/usr/bin/ruby

require 'rubygems' unless defined?(Gem)

spec = Gem::Specification.new do |s|
  ## package information
  s.name        = "merb_helpers_monkey"
  s.author      = "makoto kuwata"
  s.email       = "kwa(at)kuwata-lab.com"
  s.version     = "0.1.0"
  s.platform    = Gem::Platform::RUBY
  s.homepage    = "http://github.com/kwatch/merb_helpers_monkey"
  s.summary     = "extends some helper methods defined in merb-helpers."
  s.rubyforge_project = 'merb_helpers_monkey'
  s.description = <<-'END'
  Merb_helpers_monkey is a Merb plug-in to extend the followng helper methods
  defined in merb-helpers:
  * radio_button() - to take boolean value as :checked option.
  * field_for(), form_for(), fieldset_for() - to take new :index_by option. 
  END

  ## files
  files = %w[README.txt MIT-LICENSE lib/merb_helpers_monkey.rb]
  #files = []
  #files += Dir.glob('lib/**/*')
  #files += %w[README.txt MIT-LICENSE]
  s.files       = files
end

# Quick fix for Ruby 1.8.3 / YAML bug   (thanks to Ross Bamford)
if (RUBY_VERSION == '1.8.3')
  def spec.to_yaml
    out = super
    out = '--- ' + out unless out =~ /^---/
    out
  end
end

if $0 == __FILE__
  #Gem::manage_gems
  Gem::Builder.new(spec).build
end

spec
