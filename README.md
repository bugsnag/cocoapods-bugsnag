# cocoapods-bugsnag

A [Cocoapods](https://cocoapods.org) plugin for integrating Cocoa projects with
[Bugsnag](https://bugsnag.com), an error tracking and resolution tool.

## Installation

`cocoapods-bugsnag` is available via [RubyGems](https://rubygems.org). To
install, run:

    gem install cocoapods-bugsnag

### Installing from Source

1. Clone this repository
2. Run `bundle install` from the root of the repository (installing
   [bundler](http://bundler.io) if needed)
3. Build the gem using `gem build cocoapods-bugsnag.gemspec`
4. Install the gem using `gem install cocoapods-bugsnag-<version>.gem`

## Usage

The [Bugsnag reporting library for Cocoa](https://github.com/bugsnag/bugsnag-cocoa)
is available via Cocoapods. Once you have added Bugsnag to your Podfile, running
`pod install` will add a build phase to your project workspace to upload your
[dSYM](http://noverse.com/blog/2010/03/how-to-deal-with-an-iphone-crash-report/)
files so the Bugsnag service can provide you with symbolicated stack traces.

## Support

* [Search open and closed issues](https://github.com/bugsnag/cocoapods-bugsnag/issues?utf8=✓&q=is%3Aissue)
  for similar problems
* [Open an issue](https://github.com/bugsnag/cocoapods-bugsnag/issues/new)
