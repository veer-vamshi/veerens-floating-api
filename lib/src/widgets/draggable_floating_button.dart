import 'package:flutter/material.dart';

import 'metal_v_letter.dart';

/// Black, elevated, circular button with a chrome 'V' badge.
/// Drag reporting and tap/long-press are left to the caller.
class DraggableFloatingButton extends StatelessWidget {
  const DraggableFloatingButton({
    super.key,
    required this.size,
    required this.onDragUpdate,
    required this.onTap,
    required this.onLongPress,
  });

  final double size;
  final ValueChanged<Offset> onDragUpdate;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanUpdate: (DragUpdateDetails details) => onDragUpdate(details.delta),
      child: Material(
        color: Colors.black,
        elevation: 10,
        shadowColor: Colors.black87,
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          onLongPress: onLongPress,
          child: SizedBox(
            width: size,
            height: size,
            child: Align(
              alignment: Alignment.center,
              child: MetalVLetter(size: size * 0.52),
            ),
          ),
        ),
      ),
    );
  }
}
