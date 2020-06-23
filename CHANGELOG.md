TBD
====

Added new location for API key in `Info.plist` from
[bugsnag-cocoa v6.x](https://github.com/bugsnag/bugsnag-cocoa/releases/tag/v6.0.0).

Amended filter on `Info.plist` search so that it only removes files inside
`/build/` or `/test/` directories rather than directories with the string
"build" or "test" in them.

Add the --http1.1 option to the curl command to force use of HTTP/1.1 to
prevent the uploads of larger files from failing.

2.0.1 (04 Dec 2018)
=====

Added API key to generated upload command

2.0.0 (30 Jun 2016)
=====

Version update to support CocoaPods 1.0

1.0.1 (23 Dec 2015)
=====

### Bug Fixes

* Fix for missing specification warning during `pod install`
  | [7d70389](https://github.com/bugsnag/cocoapods-bugsnag/commit/7d70389af31b2b8807195aca3dae0e62140ff176)


1.0.0 (19 Dec 2015)
=====

Initial Release
