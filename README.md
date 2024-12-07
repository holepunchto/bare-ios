# Bare on iOS

Example of embedding Bare in an iOS application using <https://github.com/holepunchto/bare-kit>.

## Building

To keep the build process fast and efficient, the project relies on a Bare Kit prebuild being available in the [`app/frameworks/`](app/frameworks) directory. Prior to building the project, you must therefore either clone and compile Bare Kit from source, or download the latest prebuild from GitHub. The latter is easily accomplished using the [GitHub CLI](https://cli.github.com):

```console
gh release download --repo holepunchto/bare-kit <version>
```

Unpack the resulting `prebuilds.zip` archive and move `ios/BareKit.xcframework` into [`app/frameworks/`](app/frameworks). When finished, generate the Xcode project files using <https://github.com/yonaskolb/XcodeGen>:

```console
xcodegen generate
```

Then, either open the project in Xcode or build it from the commandline:

```console
xcodebuild -scheme App build
```

### Addons

Native addons will be linked into [`app/addons/`](app/addons) as part of the build process and must be referenced in [`app/addons/addons.yml`](app/addons/addons.yml) to ensure that Xcode copies them to the final app bundle. After installing `bare-addon` v1.2.3, for example, do:

```diff
 targets:
   App:
-    dependencies: []
+    dependencies:
+      - framework: bare-addon.1.2.3.xcframework
```

Make sure to regenerate the project files after editing the addons list:

```console
xcodegen generate
```

## License

Apache-2.0
