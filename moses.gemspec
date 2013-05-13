# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "moses"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dayton Nolan"]
  s.date = "2013-05-13"
  s.description = "TODO: Moses is a simple command parser for writing command line applications"
  s.email = "daytonn@gmail.com"
  s.executables = ["autospec", "coderay", "htmldiff", "jeweler", "ldiff", "pry", "rake", "ri", "rspec"]
  s.extra_rdoc_files = [
    "LICENSE",
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".DS_Store",
    ".document",
    ".rspec",
    ".ruby-version",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/autospec",
    "bin/coderay",
    "bin/htmldiff",
    "bin/jeweler",
    "bin/ldiff",
    "bin/pry",
    "bin/rake",
    "bin/ri",
    "bin/rspec",
    "lib/moses.rb",
    "moses.gemspec",
    "spec/moses_spec.rb",
    "spec/spec_helper.rb",
    "test.rb"
  ]
  s.homepage = "http://github.com/daytonn/moses"
  s.licenses = ["Apache 2.0"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "TODO: Moses is a simple command parser for writing command line applications"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<pry-nav>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<pry-nav>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<pry-nav>, [">= 0"])
  end
end

