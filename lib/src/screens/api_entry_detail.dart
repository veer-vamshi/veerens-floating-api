import 'package:flutter/material.dart';

import '../models/api_log_entry.dart';
import '../models/api_log_entry_formatter.dart';
import '../widgets/copy_share_buttons.dart';
import '../widgets/json_pretty_view.dart';
import '../widgets/section_card.dart';
import '../widgets/status_badge.dart';

/// Full-URL + request + response breakdown for a single [ApiLogEntry],
/// each piece (and the whole entry) copyable and shareable on its own.
class ApiEntryDetail extends StatelessWidget {
  const ApiEntryDetail({super.key, required this.entry});

  final ApiLogEntry entry;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              StatusBadge(statusCode: entry.statusCode, isError: entry.isError),
              const SizedBox(width: 8),
              Text(
                entry.method,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                entry.statusCode?.toString() ?? '—',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const Spacer(),
              if (entry.duration != null)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    '${entry.duration!.inMilliseconds} ms',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ),
              CopyShareButtons(text: entry.shareableAll, label: 'All'),
            ],
          ),
          const SizedBox(height: 4),
          SectionCard(
            title: 'FULL URL',
            actions: CopyShareButtons(text: entry.shareableUrl, label: 'URL'),
            child: SelectableText(
              entry.url,
              style: const TextStyle(color: Colors.white, fontFamily: 'monospace', fontSize: 13),
            ),
          ),
          SectionCard(
            title: 'REQUEST',
            actions: CopyShareButtons(text: entry.shareableRequest, label: 'Request'),
            child: JsonPrettyView(data: entry.shareableRequest),
          ),
          SectionCard(
            title: entry.isError ? 'RESPONSE / ERROR' : 'RESPONSE',
            actions: CopyShareButtons(text: entry.shareableResponse, label: 'Response'),
            child: JsonPrettyView(data: entry.shareableResponse),
          ),
        ],
      ),
    );
  }
}
