## 0.1.1

Fixes an Android build failure on some Flutter/AGP/Kotlin versions
("Unresolved reference: compilerOptions" or similar) caused by
`android/build.gradle.kts` assuming a bleeding-edge Kotlin Gradle Plugin.
It now applies the Kotlin Android plugin explicitly, pins compilation
consistently via a JVM toolchain instead of the version-specific
`kotlinOptions`/`compilerOptions` DSLs, and raises `compileSdk` to 36 to
satisfy `share_plus`'s own requirement. No Dart-level API changes.

## 0.1.0

Initial release.

- Draggable floating button, present on every screen, with a black elevated
  background and a chrome-gradient "V" badge.
- `VeerensApiInterceptor` — add to any `Dio` instance to automatically
  capture every request/response (URL, query/headers/body, status,
  response headers/body, timing) with no per-call code.
- Tap the button to inspect the latest API call, or open the history list
  (latest first) and tap any entry — both on a black/white screen with
  syntax-colored, pretty-printed JSON.
- Copy and share actions for the URL, the request, the response, and
  everything combined, each independently.
- Long-press the button to hide it on the current page only; it's visible
  again next time that page is (re)visited.
- Visibility is gated by two independent checks — either one being "off"
  hides the button entirely:
  - A manual `enabled` flag on `VeerensFloatingApi.builder()`, defaulting
    to debug builds only.
  - An automatic, native check: on Android, the installer package name
    (hidden on a Play Store/Galaxy Store/Amazon Appstore/Huawei AppGallery
    install); on iOS, the App Store receipt (hidden only on a genuine
    production App Store build, not TestFlight/ad-hoc/debug).
