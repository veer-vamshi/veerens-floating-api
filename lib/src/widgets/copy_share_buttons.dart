import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

/// A compact pair of icon buttons: copy [text] to the clipboard, or
/// share it through the platform share sheet. [label] names what's
/// being acted on (e.g. "URL", "Request", "All") for the tooltip,
/// confirmation snackbar, and share subject.
class CopyShareButtons extends StatelessWidget {
  const CopyShareButtons({super.key, required this.text, required this.label});

  final String text;
  final String label;

  Future<void> _copy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copied'), duration: const Duration(seconds: 1)),
    );
  }

  Future<void> _share() => SharePlus.instance.share(ShareParams(text: text, subject: label));

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.copy_rounded, size: 17),
          color: Colors.white60,
          tooltip: 'Copy $label',
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(6),
          onPressed: () => _copy(context),
        ),
        IconButton(
          icon: const Icon(Icons.share_rounded, size: 17),
          color: Colors.white60,
          tooltip: 'Share $label',
          visualDensity: VisualDensity.compact,
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(6),
          onPressed: _share,
        ),
      ],
    );
  }
}
