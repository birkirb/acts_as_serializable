Gem::Specification.new do |s|
  s.name = %q{acts_as_serializable}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Birkir A. Barkarson"]
  s.date = %q{2009-06-06}
  s.description = %q{Easy versioning of serialization methods}
  s.email = %q{birkirb@stoicviking.net}
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc",
             "Rakefile",
             "init.rb",
             "lib/acts_as_serializable.rb",
             "lib/version.rb",
             "lib/versions.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/birkirb/acts_as_serializable}
  s.rdoc_options = ["--title",
                    "acts_as_serializable documentation",
                    "--charset",
                    "utf-8",
                    "--opname",
                    "index.html",
                    "--line-numbers",
                    "--main",
                    "README.rdoc",
                    "--inline-source",
                    "--exclude",
                    "^(examples)/"
  ]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{serializable}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Easy versioning of serialization methods}
  s.test_files = ["spec/acts_as_serializable_spec.rb",
                  "spec/version_spec.rb",
                  "spec/versions_spec.rb",
                  "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.3.1') then
      s.add_runtime_dependency(%q<jsonbuilder>, [">= 0.0.6"])
      s.add_runtime_dependency(%q<activesupport>, [">= 1.2"])
    end
  end
end
