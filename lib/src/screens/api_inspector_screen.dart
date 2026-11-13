import 'package:flutter/material.dart';

import '../api_log_store.dart';
import '../internal_route.dart';
import '../models/api_log_entry.dart';
import 'api_entry_detail.dart';
import 'api_history_screen.dart';

/// Shows the latest captured API call, or a specific [entry] when opened
/// from the history list. Black background, white foreground, as asked.
class ApiInspectorScreen extends StatelessWidget {
  const ApiInspectorScreen({super.key, this.entry});

  final ApiLogEntry? entry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(entry == null ? 'Latest API Call' : 'API Call'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'History',
            onPressed: () => Navigator.of(context).push<void>(
              MaterialPageRoute<void>(
                settings: const RouteSettings(name: kVeerensInternalRouteName),
                builder: (_) => const ApiHistoryScreen(),
              ),
            ),
          ),
        ],
      ),
      body: entry != null
          ? ApiEntryDetail(entry: entry!)
          : AnimatedBuilder(
              animation: VeerensApiLogStore.instance,
              builder: (BuildContext context, _) {
                final ApiLogEntry? latest = VeerensApiLogStore.instance.latest;
                if (latest == null) {
                  return const Center(
                    child: Text('No API calls captured yet.', style: TextStyle(color: Colors.white54)),
                  );
                }
                return ApiEntryDetail(entry: latest);
              },
            ),
    );
  }
}
