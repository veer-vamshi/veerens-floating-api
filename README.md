# veerens_floating_api

A draggable floating "V" button, present on every screen of your app, that
inspects the latest (and full history of) API calls made through
[Dio](https://pub.dev/packages/dio) — full URL, request, and response,
pretty-printed as syntax-colored JSON, with copy and share actions.

## Features

- A black, elevated, draggable floating button with a chrome "V" badge on
  every screen.
- Tap it to see the **latest** API call: full URL, request (query / headers /
  body), and response, pretty-printed and syntax-colored on a black/white
  inspector screen.
- Tap the history icon to see **every** call, latest first; tap one to
  inspect it.
- **Copy** and **share** the URL, the request, the response, or everything
  combined — each independently, from the inspector screen.
- Long-press the button to hide it on the current page only; it's back next
  time you land on that page.
- Shown or hidden by **two independent checks** — see [Visibility](#visibility-manual--automatic-checks)
  below.

## Getting started

Add the dependency:

```yaml
dependencies:
  veerens_floating_api: ^0.0.1
  dio: ^5.0.0
```

## Usage

### 1. Capture API calls

Add `VeerensApiInterceptor` to whichever `Dio` instance makes your network
calls:

```dart
final dio = Dio()..interceptors.add(VeerensApiInterceptor());
```

Every request/response (or error) that goes through that `Dio` instance is
now captured automatically — no further code needed per call.

### 2. Show the floating button

Wire up `MaterialApp` with the route observer and the builder:

```dart
import 'package:flutter/material.dart';
import 'package:veerens_floating_api/veerens_floating_api.dart';

MaterialApp(
  navigatorObservers: [VeerensFloatingApi.routeObserver],
  builder: VeerensFloatingApi.builder(),
  home: const HomePage(),
)
```

That's the whole integration — the button now follows the app across every
screen pushed through this `Navigator`.

(Uses `MaterialApp`? `CupertinoApp` and `WidgetsApp` take the same
`navigatorObservers` and `builder` parameters, so the same two lines work
there too.)

## Visibility: manual + automatic checks

The button only shows when **both** of the following say yes — if either
says no, it's hidden completely, with no partial/flashing state:

1. **Manual flag** — the `enabled` argument to `VeerensFloatingApi.builder()`:

   ```dart
   builder: VeerensFloatingApi.builder(enabled: true), // or false
   ```

   This is where **you, the developer, manually turn it on or off.** Left
   unset, it defaults to debug builds only (`kDebugMode`). Drive it from
   your own build flavor or a `--dart-define` so it's `true` for a testing
   APK/IPA you hand out, and `false` (or just omit it) for your real release
   build.

2. **Automatic check** (native, built in — nothing to configure) — on
   Android, it reads the app's installer package name; if it was installed
   by Play Store (or Galaxy Store / Amazon Appstore / Huawei AppGallery),
   it's hidden, regardless of the manual flag. On iOS, it reads the App
   Store receipt; a production receipt (a real App Store download) hides
   it, while TestFlight, ad-hoc/enterprise, and Xcode debug builds have no
   production receipt, so the button still shows there.

   This exists as a safety net: if you forget to flip the manual flag off
   before shipping to the store, the automatic check still catches it.

### Where to integrate this

Put the two lines from [Usage](#usage) in your app's root widget — wherever
your `MaterialApp`/`CupertinoApp`/`WidgetsApp` is constructed — and add the
interceptor wherever you construct your shared `Dio` instance. Nothing else
in your app needs to change; every screen pushed through that `Navigator`
gets the button automatically.

See `example/lib/main.dart` for a complete, runnable app that hits a public
test API.

## Additional information

Found a bug or want a feature? Open an issue on the repository. Contributions
welcome.
