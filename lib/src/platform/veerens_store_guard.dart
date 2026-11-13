import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Native, automatic check: is this app currently running as a genuine
/// store install (Play Store on Android, App Store on iOS)?
///
/// This is combined with the manual `enabled` flag so the floating
/// button stays off a real store build even if a developer forgets to
/// flip the manual flag before shipping — and still shows for anything
/// that isn't a store install: debug builds, sideloaded/testing APKs,
/// TestFlight and ad-hoc/enterprise IPAs.
class VeerensStoreGuard {
  VeerensStoreGuard._();

  static const MethodChannel _channel = MethodChannel('veerens_floating_api');

  static Future<bool>? _cached;

  /// Cached after the first call — the install source can't change
  /// while the process is alive.
  static Future<bool> isStoreInstall() => _cached ??= _check();

  @visibleForTesting
  static void debugResetForTesting() => _cached = null;

  static Future<bool> _check() async {
    final bool isMobile =
        defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
    if (!isMobile) return false;

    try {
      // A timeout, not just a catch: some environments (and the odd
      // misbehaving OEM build) never reply at all rather than cleanly
      // throwing MissingPluginException, which would otherwise hang the
      // gate forever instead of just defaulting to "show the button".
      final bool? result = await _channel.invokeMethod<bool>('isStoreInstall').timeout(
            const Duration(seconds: 2),
            onTimeout: () => false,
          );
      return result ?? false;
    } on MissingPluginException {
      return false;
    } catch (_) {
      return false;
    }
  }
}
