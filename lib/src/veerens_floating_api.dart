import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'api_log_store.dart';
import 'models/api_log_entry.dart';
import 'veerens_floating_overlay.dart';
import 'veerens_route_observer.dart';

/// Entry point for the floating API inspector button.
///
/// Wiring it up in the host app:
///
/// ```dart
/// MaterialApp(
///   navigatorObservers: [VeerensFloatingApi.routeObserver],
///   builder: VeerensFloatingApi.builder(),
///   home: const HomePage(),
/// )
/// ```
///
/// and on whichever [Dio] instance makes the API calls:
///
/// ```dart
/// dio.interceptors.add(VeerensApiInterceptor());
/// ```
class VeerensFloatingApi {
  VeerensFloatingApi._();

  /// Add to `MaterialApp(navigatorObservers: [...])` so the button knows
  /// which screen it's on (needed for the per-page hide/show behavior).
  static final NavigatorObserver routeObserver = VeerensRouteObserver();

  /// Builds the `MaterialApp.builder` that overlays the draggable button
  /// on every screen.
  ///
  /// [enabled] controls whether the button shows at all. Flutter's
  /// release mode is identical for a sideloaded testing APK and a
  /// Play Store/App Store build, so there is no automatic way to tell
  /// them apart — pass this explicitly for that case (e.g. driven by
  /// your own build flavor or a `--dart-define`). Left unset, it
  /// defaults to debug builds only ([kDebugMode]).
  static TransitionBuilder builder({bool? enabled}) {
    final bool resolvedEnabled = enabled ?? kDebugMode;
    return (BuildContext context, Widget? child) {
      final Widget content = child ?? const SizedBox.shrink();
      return resolvedEnabled ? VeerensFloatingOverlay(child: content) : content;
    };
  }

  /// All captured API calls, latest first.
  static List<ApiLogEntry> get history => VeerensApiLogStore.instance.entries;

  /// Clears captured API call history.
  static void clearHistory() => VeerensApiLogStore.instance.clear();
}
