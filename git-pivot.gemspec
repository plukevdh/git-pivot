# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = "git-pivot"
  s.version     = "0.0.1"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Luke van der Hoeven"]
  s.email       = ["hungerandthirst@gmail.com"]
  s.homepage    = "https://github.com/plukevdh/git-pivot"
  s.summary     = %q{GitPivot: Integrate your git and pivotal workflow.}
  s.description = %q{GitPivot is a Git/Github/PivotalTracker integration toolset. It tries to lighten you workflow to a smaller set of commands.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "grit"
  s.add_dependency "pivotal-tracker"
  s.add_dependency "thor"

  s.add_development_dependency "rspec"
end
