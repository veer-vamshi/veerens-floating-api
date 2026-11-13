import 'package:flutter/material.dart';

import 'internal_route.dart';
import 'platform/veerens_store_guard.dart';
import 'screens/api_inspector_screen.dart';
import 'veerens_floating_api_controller.dart';
import 'widgets/draggable_floating_button.dart';

/// Wraps the app content with the draggable floating button, kept alive
/// across route changes since it lives above the app's [Navigator].
class VeerensFloatingOverlay extends StatefulWidget {
  const VeerensFloatingOverlay({super.key, required this.child});

  final Widget child;

  @override
  State<VeerensFloatingOverlay> createState() => _VeerensFloatingOverlayState();
}

class _VeerensFloatingOverlayState extends State<VeerensFloatingOverlay> {
  static const double _buttonSize = 44;

  final VeerensFloatingApiController _controller = VeerensFloatingApiController.instance;

  // null while the automatic store-install check is still pending; the
  // button stays hidden until it resolves, so it never flashes on a
  // real store build.
  bool _automaticCheckPassed = false;

  int _positionAttempts = 0;
  static const int _maxPositionAttempts = 10;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureDefaultPosition());
    VeerensStoreGuard.isStoreInstall().then((bool isStoreInstall) {
      if (mounted) setState(() => _automaticCheckPassed = !isStoreInstall);
    });
  }

  void _ensureDefaultPosition() {
    if (!mounted || _controller.position.value != null) return;
    final Size size = MediaQuery.of(context).size;

    // On a real device's cold start, the first reported window size can
    // briefly be zero (native view not laid out yet) — wait for a real
    // one instead of locking in a bogus off-screen position. Capped, so
    // a size that never becomes valid can't retry forever.
    final bool sizeInvalid = size.width <= 0 || size.height <= 0;
    if (sizeInvalid && _positionAttempts < _maxPositionAttempts) {
      _positionAttempts++;
      WidgetsBinding.instance.addPostFrameCallback((_) => _ensureDefaultPosition());
      return;
    }

    final double width = size.width > 0 ? size.width : 360;
    final double height = size.height > 0 ? size.height : 690;
    _controller.position.value = Offset(
      width - _buttonSize - 16,
      height - _buttonSize - 96,
    );
  }

  void _openInspector() {
    // The overlay sits above the Navigator in the tree (it wraps `child`,
    // which contains the Navigator), so there's no Navigator ancestor to
    // find via `context` here. Push through the current route's own
    // navigator instead.
    _controller.currentRoute.value?.navigator?.push<void>(
      MaterialPageRoute<void>(
        settings: const RouteSettings(name: kVeerensInternalRouteName),
        builder: (_) => const ApiInspectorScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final EdgeInsets padding = MediaQuery.of(context).padding;

    return Stack(
      children: <Widget>[
        widget.child,
        AnimatedBuilder(
          animation: Listenable.merge(
            <Listenable>[_controller.position, _controller.currentRoute, _controller.hiddenTick],
          ),
          builder: (BuildContext context, _) {
            final Offset? pos = _controller.position.value;
            if (pos == null || !_automaticCheckPassed) return const SizedBox.shrink();

            final Route<dynamic>? route = _controller.currentRoute.value;
            final bool isInternalScreen = route?.settings.name == kVeerensInternalRouteName;
            if (isInternalScreen || _controller.isHidden(route)) {
              return const SizedBox.shrink();
            }

            return Positioned(
              left: pos.dx,
              top: pos.dy,
              child: DraggableFloatingButton(
                size: _buttonSize,
                onDragUpdate: (Offset delta) {
                  final Offset next = pos + delta;
                  _controller.position.value = Offset(
                    next.dx.clamp(0.0, screenSize.width - _buttonSize),
                    next.dy.clamp(padding.top, screenSize.height - _buttonSize - padding.bottom),
                  );
                },
                onTap: _openInspector,
                onLongPress: _controller.hideForCurrentRoute,
              ),
            );
          },
        ),
      ],
    );
  }
}
