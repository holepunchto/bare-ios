# Bare on iOS

A peer-to-peer **shared switch** for iOS - the iOS shell over [bare-switch-core](https://github.com/holepunchto/bare-switch-core), the same core that powers [bare-macos](https://github.com/holepunchto/bare-macos). Flip the switch on one device and it flips on every other copy, connected directly device to device with no server. (It also keeps a Bare-powered push-notification service extension as a second worklet.)

## Building

One-time setup:

```sh
npm install
gh release download --repo holepunchto/bare-kit v2.1.3 --pattern prebuilds.zip
unzip prebuilds.zip "ios/*" -d prebuilds/
mv prebuilds/ios/BareKit.xcframework app/frameworks/
xcodegen generate
```

Then build (or open in Xcode):

```sh
xcodebuild -scheme App -sdk iphonesimulator build
```

The scheme's pre-actions link the native addons (`bare-link`) and pack two worklets: the switch (`bare-switch-core`'s `backend.js` -> `app.bundle`) and the push handler (`app/push.js` -> `push.bundle`).

To change the switch protocol or worklet, edit [bare-switch-core](https://github.com/holepunchto/bare-switch-core); this repo consumes its committed, generated bindings.

## License

Apache-2.0
