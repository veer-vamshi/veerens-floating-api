import 'package:flutter/material.dart';

/// Small colored dot/chip reflecting an HTTP status code (or error/pending).
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, this.statusCode, this.isError = false});

  final int? statusCode;
  final bool isError;

  Color get _color {
    if (isError || (statusCode != null && statusCode! >= 400)) return Colors.redAccent;
    if (statusCode != null && statusCode! >= 200 && statusCode! < 300) return Colors.greenAccent;
    if (statusCode == null) return Colors.white38;
    return Colors.orangeAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
    );
  }
}
