# frozen_string_literal: true

source 'https://rubygems.org'

gemspec

def cocoapods_gem(name, gem_name = name.downcase, **opts)
  gem gem_name, git: "https://github.com/CocoaPods/#{name}", **opts
end

group :development do
  cocoapods_gem 'CocoaPods'
  cocoapods_gem 'Core', 'cocoapods-core'
  cocoapods_gem 'Xcodeproj'

  gem 'rspec'
end
