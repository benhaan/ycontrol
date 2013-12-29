# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ycontrol/version"

Gem::Specification.new do |s|
  s.name        = "ycontrol"
  s.version     = YControl::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ben Haan"]
  s.email       = ["benhaan@gmail.com"]
  s.homepage    = "http://github.com/benhaan/ycontrol"
  s.summary     = %q{Control your network enabled Yamaha receiver from ruby.}
  s.description = %q{Control your network enabled Yamaha receiver from ruby.}

  s.required_ruby_version     = '>= 1.9.3'

  s.add_dependency 'libxml-ruby', '~> 2.6'
  s.add_dependency 'httparty', '~> 0.12.0'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]
end