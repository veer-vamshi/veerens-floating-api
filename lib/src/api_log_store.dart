import 'package:flutter/foundation.dart';

import 'models/api_log_entry.dart';

/// In-memory store of captured API calls, newest last internally.
///
/// Extends [ChangeNotifier] so UI (the inspector/history screens) can
/// listen and rebuild live as new calls come in.
class VeerensApiLogStore extends ChangeNotifier {
  VeerensApiLogStore._();

  static final VeerensApiLogStore instance = VeerensApiLogStore._();

  final List<ApiLogEntry> _entries = <ApiLogEntry>[];

  /// All captured entries, latest first.
  List<ApiLogEntry> get entries => List.unmodifiable(_entries.reversed);

  /// The most recently captured entry, if any.
  ApiLogEntry? get latest => _entries.isEmpty ? null : _entries.last;

  void add(ApiLogEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void clear() {
    _entries.clear();
    notifyListeners();
  }
}
