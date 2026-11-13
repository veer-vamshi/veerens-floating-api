import 'dart:convert';

import 'api_log_entry.dart';

/// Pretty-printed JSON text for copy/share, built from an [ApiLogEntry].
extension ApiLogEntryFormatter on ApiLogEntry {
  static const JsonEncoder _encoder = JsonEncoder.withIndent('  ');

  String get shareableUrl => url;

  Map<String, dynamic> get _requestMap => <String, dynamic>{
        'method': method,
        'url': url,
        if (queryParameters != null && queryParameters!.isNotEmpty) 'queryParameters': queryParameters,
        if (requestHeaders != null && requestHeaders!.isNotEmpty) 'headers': requestHeaders,
        if (requestBody != null) 'body': requestBody,
      };

  Map<String, dynamic> get _responseMap => <String, dynamic>{
        if (statusCode != null) 'statusCode': statusCode,
        if (responseHeaders != null && responseHeaders!.isNotEmpty) 'headers': responseHeaders,
        if (responseBody != null) 'body': responseBody,
        if (errorMessage != null) 'error': errorMessage,
      };

  String get shareableRequest => _encoder.convert(_requestMap);

  String get shareableResponse => _encoder.convert(_responseMap);

  String get shareableAll => _encoder.convert(<String, dynamic>{
        'url': url,
        'timestamp': timestamp.toIso8601String(),
        'request': _requestMap,
        'response': _responseMap,
      });
}
