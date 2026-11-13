import 'package:flutter/widgets.dart';

/// Holds the floating button's live state: its dragged position, which
/// route is currently on screen, and which routes have had the button
/// long-press-hidden.
class VeerensFloatingApiController {
  VeerensFloatingApiController._();

  static final VeerensFloatingApiController instance = VeerensFloatingApiController._();

  /// Current on-screen position of the button. `null` until the first
  /// frame lays it out at its default position.
  final ValueNotifier<Offset?> position = ValueNotifier<Offset?>(null);

  /// The topmost route of the observed [Navigator].
  final ValueNotifier<Route<dynamic>?> currentRoute = ValueNotifier<Route<dynamic>?>(null);

  /// Bumped whenever [_hiddenRoutes] changes, so listeners relying only on
  /// [currentRoute]/[position] still rebuild when visibility changes.
  final ValueNotifier<int> hiddenTick = ValueNotifier<int>(0);

  final Set<Route<dynamic>> _hiddenRoutes = <Route<dynamic>>{};

  bool isHidden(Route<dynamic>? route) => route != null && _hiddenRoutes.contains(route);

  /// Long-press behavior: hide the button for the route currently on screen.
  void hideForCurrentRoute() {
    final Route<dynamic>? route = currentRoute.value;
    if (route != null && _hiddenRoutes.add(route)) {
      hiddenTick.value++;
    }
  }

  /// Called once a route is popped/removed so a future, fresh instance of
  /// that page starts visible again ("shows back again on refresh").
  void releaseRoute(Route<dynamic> route) {
    if (_hiddenRoutes.remove(route)) {
      hiddenTick.value++;
    }
  }
}
