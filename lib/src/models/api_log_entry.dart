/// A single captured API call: its request and its response (or error).
class ApiLogEntry {
  ApiLogEntry({
    required this.id,
    required this.timestamp,
    required this.method,
    required this.url,
    this.queryParameters,
    this.requestBody,
    this.requestHeaders,
    this.statusCode,
    this.responseBody,
    this.responseHeaders,
    this.errorMessage,
    this.duration,
  });

  final String id;
  final DateTime timestamp;
  final String method;
  final String url;

  final Map<String, dynamic>? queryParameters;
  final dynamic requestBody;
  final Map<String, dynamic>? requestHeaders;

  final int? statusCode;
  final dynamic responseBody;
  final Map<String, dynamic>? responseHeaders;

  final String? errorMessage;
  final Duration? duration;

  bool get isError => errorMessage != null || (statusCode != null && statusCode! >= 400);
}
