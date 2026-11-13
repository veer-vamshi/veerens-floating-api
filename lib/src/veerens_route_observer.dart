import 'package:flutter/widgets.dart';

import 'veerens_floating_api_controller.dart';

/// Tracks the current top-most route so the floating button knows which
/// page it's on. Add this to `MaterialApp(navigatorObservers: [...])`.
class VeerensRouteObserver extends NavigatorObserver {
  final VeerensFloatingApiController _controller = VeerensFloatingApiController.instance;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _controller.currentRoute.value = route;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _controller.releaseRoute(route);
    _controller.currentRoute.value = previousRoute;
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _controller.releaseRoute(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (oldRoute != null) _controller.releaseRoute(oldRoute);
    if (newRoute != null) _controller.currentRoute.value = newRoute;
  }
}
