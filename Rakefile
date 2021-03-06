require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = %q{acts_as_serializable}
    s.authors = ["Birkir A. Barkarson"]
    s.description = %q{Easy versioning of serialization methods}
    s.summary = s.description
    s.email = %q{birkirb@stoicviking.net}
    s.has_rdoc = true
    s.homepage = %q{http://github.com/birkirb/acts_as_serializable}
    s.rubyforge_project = %q{serializable}
    s.rubygems_version = %q{1.3.1}
    s.add_dependency(%q<builder>, ["<= 2.1.2"])
    s.add_dependency(%q<jsonbuilder>, [">= 0.1.0"])
    s.add_dependency(%q<activesupport>, [">= 1.2"])
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new('spec') do |t|
    t.rspec_opts = ["-fd", "-c"]
    t.pattern = 'spec/**/*_spec.rb'
  end
rescue LoadError
  desc 'Spec rake task not available'
  task :spec do
    abort 'Spec rake task is not available. Be sure to install rspec as a gem or plugin'
  end
end

begin
  require 'spec/rake/spectask'
  require 'spec/rake/verify_rcov'

  task :test do
    Rake::Task[:spec].invoke
  end

  desc "Run tests with RCov"
  namespace :rcov do
    rm "coverage.data" if File.exist?("coverage.data")


    Spec::Rake::SpecTask.new(:spec) do |t|
      t.spec_opts = ["-f specdoc", "-c"]
      t.spec_files = FileList['spec/*_spec.rb']
      t.rcov = true
      t.rcov_opts = %w{--exclude "spec/*,gems/*,features/*" --aggregate "coverage.data"}
    end

    desc "Run both specs and features to generate aggregated coverage"
    task :all do |t|
      Rake::Task["rcov:spec"].invoke
    end

    RCov::VerifyTask.new(:verify => 'rcov:all') do |t|
      t.threshold = 100.0
      t.index_html = 'coverage/index.html'
    end
  end
rescue LoadError
  desc 'Rcov rake task not available'
  task :rcov do
    abort 'rcov rake task is not available. Be sure to install rspec, rcov and cucumber as a gem or plugin'
  end
end

begin
  require 'metric_fu'

  MetricFu::Configuration.run do |config|
    #define which metrics you want to use
    config.metrics  = [:churn, :flog, :flay, :reek, :roodi]
    config.flay     = { :dirs_to_flay => ['app', 'lib']  } 
    config.flog     = { :dirs_to_flog => ['app', 'lib']  }
    config.reek     = { :dirs_to_reek => ['app', 'lib']  }
    config.roodi    = { :dirs_to_roodi => ['app', 'lib'] }
    config.saikuro  = { :output_directory => 'scratch_directory/saikuro', 
      :input_directory => ['app', 'lib'],
      :cyclo => "",
      :filter_cyclo => "0",
      :warn_cyclo => "5",
      :error_cyclo => "7",
      :formater => "text"} #this needs to be set to "text"
    config.churn    = { :start_date => "1 year ago", :minimum_churn_count => 10}
    config.rcov     = { :test_files => ['test/**/*_test.rb', 
      'spec/**/*_spec.rb'],
      :rcov_opts => ["--sort coverage", 
        "--no-html", 
        "--text-coverage",
        "--no-color",
        "--profile",
        "--rails",
        "--exclude /gems/,/Library/,spec"]}
  end

rescue LoadError
  # Too bad
end

task :default => [:spec]
