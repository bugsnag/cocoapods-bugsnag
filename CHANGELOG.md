# Changelog

## TBD

### Enhancements

* The Xcode build phase now outputs dSYM upload information to the Xcode build logs.
  | [#31](https://github.com/bugsnag/cocoapods-bugsnag/pull/31)

## 2.3.0 (13 Sept 2022)

### Enhancements

* The Xcode build phase is now compatible with Xcode 14's `ENABLE_USER_SCRIPT_SANDBOXING` build setting.
  This requires all dSYM files to be specified in the build phase's "Input Files" list.
  | [#28](https://github.com/bugsnag/cocoapods-bugsnag/pull/28)

## 2.2.2 (17 May 2022)

### Enhancements

* Uploading can now be skipped by setting `DISABLE_COCOAPODS_BUGSNAG=YES` via Xcode's Build Settings, `xcconfig` or `xcodebuild`.
  | [#25](https://github.com/bugsnag/cocoapods-bugsnag/pull/25)

## 2.2.1 (20 Nov 2020)

### Bug fixes

* The Xcode build phase now specifies its dependencies for improved reliability with Xcode's new build system.
  | [#20](https://github.com/bugsnag/cocoapods-bugsnag/pull/20)

## 2.2.0 (30 Sept 2020)

### Enhancements

* This plugin now finds `Info.plist` using Xcode environment variables, rather than a `glob` operation for robustness.
  | [#15](https://github.com/bugsnag/cocoapods-bugsnag/pull/15)

* This plugin will now only add itself to your Xcode project if it is explicitly added as a plugin in your `Podfile`. Previously it would install if `Bugsnag` was detected in your `Podfile`.
  | [#16](https://github.com/bugsnag/cocoapods-bugsnag/pull/16)

## 2.1.0 (14 Aug 2020)

### Enhancements

* Added new location for API key in `Info.plist` from [bugsnag-cocoa v6.x](https://github.com/bugsnag/bugsnag-cocoa/releases/tag/v6.0.0).
  | [#9](https://github.com/bugsnag/cocoapods-bugsnag/pull/9)

* Process now fails if no API key can be found before the upload begins
  | [b624b58](https://github.com/bugsnag/cocoapods-bugsnag/commit/b624b58079a45cff55fed297bcf2ebc6073069a5) fixes [#5](https://github.com/bugsnag/cocoapods-bugsnag/issues/5)

### Bug fixes

* Added the --http1.1 option to the curl command to force use of HTTP/1.1 to prevent the uploads of larger files from failing.
  | [#8](https://github.com/bugsnag/cocoapods-bugsnag/pull/8)

## 2.0.1 (04 Dec 2018)

### Enhancements

* Added API key to generated upload command
  | [#4](https://github.com/bugsnag/cocoapods-bugsnag/pull/4)

## 2.0.0 (30 Jun 2016)

Version update to support CocoaPods 1.0

## 1.0.1 (23 Dec 2015)

### Bug Fixes

* Fix for missing specification warning during `pod install`
  | [7d70389](https://github.com/bugsnag/cocoapods-bugsnag/commit/7d70389af31b2b8807195aca3dae0e62140ff176)

## 1.0.0 (19 Dec 2015)

Initial Release
