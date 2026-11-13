import 'package:flutter/material.dart';

/// The 'V' glyph with a brushed/chrome metal gradient, like a car badge.
class MetalVLetter extends StatelessWidget {
  const MetalVLetter({super.key, this.size = 24});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (Rect bounds) => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          Color(0xFFF2F2F2),
          Color(0xFFBDBDBD),
          Color(0xFFFFFFFF),
          Color(0xFF8A8A8A),
          Color(0xFFE8E8E8),
        ],
        stops: <double>[0.0, 0.3, 0.5, 0.75, 1.0],
      ).createShader(bounds),
      child: Text(
        'V',
        textAlign: TextAlign.center,
        strutStyle: StrutStyle(fontSize: size, height: 1, leading: 0, forceStrutHeight: true),
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w900,
          letterSpacing: 0,
          color: Colors.white,
          height: 1,
          shadows: const <Shadow>[
            Shadow(color: Colors.black54, offset: Offset(0, 1), blurRadius: 1),
          ],
        ),
      ),
    );
  }
}
