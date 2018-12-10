lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'daimyo/version'

Gem::Specification.new do |spec|
  spec.name          = 'daimyo'
  spec.version       = Daimyo::VERSION
  spec.authors       = ['inokappa']
  spec.email         = ['inokappa at gmail.com']

  spec.summary       = %q{It is a tool to edit Markdown format file in local environment}
  spec.description   = %q{It is a tool to edit Markdown format file in local environment}
  spec.homepage      = 'https://github.com/inokappa/daimyo'
  spec.license       = 'MIT'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'octorelease'
  spec.add_dependency 'thor'
  spec.add_dependency 'backlog_kit'
  spec.add_dependency 'diffy'
  spec.add_dependency 'terminal-table'
  spec.add_dependency 'ruby-progressbar'
end
