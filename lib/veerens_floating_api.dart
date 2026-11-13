/// A draggable floating button, present on every screen, that opens a
/// black/white inspector showing the latest (and full history of) API
/// calls made through a [Dio] instance — full URL, request, and
/// response, pretty-printed as JSON.
library;

export 'src/models/api_log_entry.dart';
export 'src/veerens_api_interceptor.dart';
export 'src/veerens_floating_api.dart';
