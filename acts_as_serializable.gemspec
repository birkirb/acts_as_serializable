# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{acts_as_serializable}
  s.version = "0.1.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Birkir A. Barkarson"]
  s.date = %q{2009-06-18}
  s.description = %q{Easy versioning of serialization methods}
  s.email = %q{birkirb@stoicviking.net}
  s.extra_rdoc_files = [
    "README.rdoc"
  ]
  s.files = [
    ".gitignore",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "acts_as_serializable.gemspec",
     "init.rb",
     "lib/acts_as_serializable.rb",
     "lib/serializable/version.rb",
     "lib/serializable/versions.rb",
     "spec/acts_as_serializable_spec.rb",
     "spec/app/serializations/test_rails_model/version_1_0_0.rb",
     "spec/app/serializations/test_rails_model/version_1_5.rb",
     "spec/app/serializations/test_rails_model/version_2_1.rb",
     "spec/serializations/test_model/version_1_0_0.rb",
     "spec/serializations/test_model/version_1_5.rb",
     "spec/serializations/test_model/version_2_1.rb",
     "spec/spec_helper.rb",
     "spec/version_spec.rb",
     "spec/versions_spec.rb"
  ]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/birkirb/acts_as_serializable}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{serializable}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Easy versioning of serialization methods}
  s.test_files = [
    "spec/spec_helper.rb",
     "spec/acts_as_serializable_spec.rb",
     "spec/versions_spec.rb",
     "spec/version_spec.rb",
     "spec/serializations/test_model/version_1_0_0.rb",
     "spec/serializations/test_model/version_2_1.rb",
     "spec/serializations/test_model/version_1_5.rb",
     "spec/app/serializations/test_rails_model/version_1_0_0.rb",
     "spec/app/serializations/test_rails_model/version_2_1.rb",
     "spec/app/serializations/test_rails_model/version_1_5.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jsonbuilder>, [">= 0.0.6"])
      s.add_runtime_dependency(%q<activesupport>, [">= 1.2"])
    else
      s.add_dependency(%q<jsonbuilder>, [">= 0.0.6"])
      s.add_dependency(%q<activesupport>, [">= 1.2"])
    end
  else
    s.add_dependency(%q<jsonbuilder>, [">= 0.0.6"])
    s.add_dependency(%q<activesupport>, [">= 1.2"])
  end
end
