# cocoapods-bugsnag

A [CocoaPods](https://cocoapods.org) plugin for integrating Cocoa projects with
[Bugsnag](https://bugsnag.com), an error tracking and resolution tool. When
installed, the plugin will add a Run Script build phase to your project workspace
to upload your
[dSYM](http://noverse.com/blog/2010/03/how-to-deal-with-an-iphone-crash-report/)
files so the Bugsnag service can provide you with symbolicated stack traces.

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

To add the build phase to your project, add `pod 'Bugsnag'`, and `plugin 'cocoapods-bugsnag'` to your `Podfile`:

```ruby
pod 'Bugsnag'
plugin 'cocoapods-bugsnag'
```

Then, install with: 

```bash
pod install
```

Once added, uploading your dSYM files to Bugsnag will occur automatically.

By default, your Bugsnag API key will either be read from the `BUGSNAG_API_KEY`
environment variable or from the `bugsnag.apiKey` (or `BugsnagAPIKey`) value in your
`Info.plist`. Alternatively edit the script in the new "Upload Bugsnag dSYM" build 
phase in Xcode.

## Support

* [Symbolication guide](https://docs.bugsnag.com/platforms/ios/symbolication-guide/)
* [Search open and closed issues](https://github.com/bugsnag/cocoapods-bugsnag/issues?utf8=✓&q=is%3Aissue)
  for similar problems
* [Open an issue](https://github.com/bugsnag/cocoapods-bugsnag/issues/new)
