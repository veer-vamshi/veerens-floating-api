import 'dart:convert';

import 'package:flutter/material.dart';

/// Renders any JSON-able value (Map/List/primitive) or raw string as
/// indented, syntax-colored, selectable text on a dark background.
class JsonPrettyView extends StatelessWidget {
  const JsonPrettyView({super.key, required this.data});

  final dynamic data;

  static const Color _keyColor = Color(0xFF7FDBFF);
  static const Color _stringColor = Color(0xFFB5F4A5);
  static const Color _keywordColor = Color(0xFFC792EA);
  static const Color _numberColor = Color(0xFFF78C6C);
  static const Color _punctuationColor = Colors.white54;

  static final RegExp _tokenPattern = RegExp(
    r'("(?:\\.|[^"\\])*")(\s*:)?'
    r'|\b(true|false|null)\b'
    r'|(-?\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)'
    r'|([{}\[\],])',
  );

  String get _source {
    if (data == null) return 'null';
    if (data is String) {
      final String raw = data as String;
      try {
        return const JsonEncoder.withIndent('  ').convert(jsonDecode(raw));
      } catch (_) {
        return raw;
      }
    }
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (_) {
      return data.toString();
    }
  }

  List<TextSpan> _highlight(String source) {
    final List<TextSpan> spans = <TextSpan>[];
    int last = 0;
    for (final RegExpMatch match in _tokenPattern.allMatches(source)) {
      if (match.start > last) {
        spans.add(TextSpan(text: source.substring(last, match.start)));
      }
      final String text = match.group(0)!;
      final Color color;
      if (match.group(1) != null) {
        color = match.group(2) != null ? _keyColor : _stringColor;
      } else if (match.group(3) != null) {
        color = _keywordColor;
      } else if (match.group(4) != null) {
        color = _numberColor;
      } else {
        color = _punctuationColor;
      }
      spans.add(TextSpan(text: text, style: TextStyle(color: color)));
      last = match.end;
    }
    if (last < source.length) {
      spans.add(TextSpan(text: source.substring(last)));
    }
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        children: _highlight(_source),
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 13,
          height: 1.5,
          color: Colors.white70,
        ),
      ),
    );
  }
}
