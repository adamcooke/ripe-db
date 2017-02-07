require File.expand_path('../lib/ripe/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = "ripe-db"
  s.description   = %q{A Ruby library for inteacting with the RIPE database}
  s.summary       = s.description
  s.homepage      = "https://github.com/adamcooke/ripe-db"
  s.version       = RIPE::VERSION
  s.files         = Dir.glob("{lib}/**/*")
  s.require_paths = ["lib"]
  s.authors       = ["Adam Cooke"]
  s.email         = ["me@adamcooke.io"]
  s.licenses      = ['MIT']
end
