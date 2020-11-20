Gem::Specification.new do |spec|
  spec.name = "cocoapods-bugsnag"
  spec.version = "2.2.1"
  spec.homepage = "https://bugsnag.com"
  spec.description = "Configures the dSYM upload phase of your project when integrated with bugsnag."
  spec.summary = "To get meaningful stacktraces from your crashes, the Bugsnag service needs your dSYM file for your build. This plugin adds an upload phase to your project where needed."
  spec.authors = [ "Delisa Mason" ]
  spec.email = [ "delisa@bugsnag.com" ]
  spec.files = [
    "lib/cocoapods_bugsnag.rb",
    "lib/cocoapods_plugin.rb",
    "cocoapods-bugsnag.gemspec"
  ]
  spec.extra_rdoc_files = [ "README.md", "CHANGELOG.md" ]
  spec.test_files = [ "spec/cocoapods_bugsnag_spec.rb" ]
  spec.require_paths = [ "lib" ]
  spec.license = "MIT"

  spec.add_dependency "cocoapods", "~> 1.0"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "bacon", "~> 1.0"
end
