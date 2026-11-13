import 'package:flutter/material.dart';

import '../api_log_store.dart';
import '../internal_route.dart';
import '../models/api_log_entry.dart';
import '../widgets/status_badge.dart';
import 'api_inspector_screen.dart';

/// All captured API calls, latest first. Tap one to inspect it.
class ApiHistoryScreen extends StatelessWidget {
  const ApiHistoryScreen({super.key});

  String _formatTime(DateTime t) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(t.hour)}:${two(t.minute)}:${two(t.second)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('API History'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear history',
            onPressed: VeerensApiLogStore.instance.clear,
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: VeerensApiLogStore.instance,
        builder: (BuildContext context, _) {
          final List<ApiLogEntry> entries = VeerensApiLogStore.instance.entries;
          if (entries.isEmpty) {
            return const Center(
              child: Text('No API calls captured yet.', style: TextStyle(color: Colors.white54)),
            );
          }
          return ListView.separated(
            itemCount: entries.length,
            separatorBuilder: (_, _) => const Divider(color: Colors.white12, height: 1),
            itemBuilder: (BuildContext context, int index) {
              final ApiLogEntry entry = entries[index];
              return ListTile(
                leading: StatusBadge(statusCode: entry.statusCode, isError: entry.isError),
                title: Text(
                  entry.url,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                ),
                subtitle: Text(
                  '${entry.method}  •  ${entry.statusCode ?? '—'}  •  ${_formatTime(entry.timestamp)}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    settings: const RouteSettings(name: kVeerensInternalRouteName),
                    builder: (_) => ApiInspectorScreen(entry: entry),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
