Gem::Specification.new do |s|
  s.name        = "kazius-alerts"
  s.version     = "0.0.4"
  s.authors     = ["Christoph Helma"]
  s.email       = ["helma@in-silico.ch"]
  s.homepage    = "http://github.com/opentox/kazius-alerts"
  s.summary     = %q{Kazius structural alerts}
  s.license     = 'GPL-3.0'

  s.rubyforge_project = "kazius-alerts"
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
end
