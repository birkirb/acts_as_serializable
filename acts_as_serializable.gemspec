Gem::Specification.new do |s|
  s.name = %q{acts_as_serializable}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Birkir A. Barkarson"]
  s.date = %q{2009-06-06}
  s.description = %q{Easy versioning of serialization methods}
  s.email = %q{birkirb@stoicviking.net}
  s.extra_rdoc_files = ["README"]
  s.files = ["README", "Rakefile", "spec/*", "lib/*", "init.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  #s.homepage = %q{}
  s.rdoc_options = ["--title", "acts_as_serializable documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples)/"]
  s.require_paths = ["lib"]
  #s.rubyforge_project = %q{}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Easy versioning of serialization methods}
  s.test_files = ["spec/acts_as_serializable.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jsonbuilder>)
      s.add_runtime_dependency(%q<active_support>, [">= 1.2"])
    end
  end
end
