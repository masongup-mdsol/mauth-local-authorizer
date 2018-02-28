require File.expand_path('lib/mauth-local-authorizer/info', File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.author = 'Mason Gup'
  s.email = 'mgup@mdsol.com'
  s.name = MAuthLocalAuthorizer::Info::NAME
  s.summary = MAuthLocalAuthorizer::Info::SUMMARY
  s.version = MAuthLocalAuthorizer::Info::VERSION
  s.description = MAuthLocalAuthorizer::Info::DESCRIPTION
  s.require_paths = ['lib']
  s.executables = ['mauth-local-authorizer']
  s.files = Dir['lib/*.rb'] + Dir['lib/**/*.rb'] + Dir['bin/*']
  s.homepage = 'https://www.github.com/'
  s.license = 'MIT'
  s.bindir = 'bin'

  s.add_runtime_dependency 'escort', '~> 0.4.0'
end
