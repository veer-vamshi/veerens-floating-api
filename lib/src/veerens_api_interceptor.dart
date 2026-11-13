import 'package:dio/dio.dart';

import 'api_log_store.dart';
import 'models/api_log_entry.dart';

/// Add this to a [Dio] instance to capture every request/response into
/// the floating API inspector:
///
/// ```dart
/// final dio = Dio();
/// dio.interceptors.add(VeerensApiInterceptor());
/// ```
class VeerensApiInterceptor extends Interceptor {
  static const String _startTimeKey = '__veerens_floating_api_start_time__';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startTimeKey] = DateTime.now();
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _capture(response.requestOptions, response: response);
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _capture(err.requestOptions, response: err.response, error: err);
    super.onError(err, handler);
  }

  void _capture(RequestOptions options, {Response<dynamic>? response, DioException? error}) {
    final DateTime? start = options.extra[_startTimeKey] as DateTime?;
    final DateTime now = DateTime.now();

    VeerensApiLogStore.instance.add(
      ApiLogEntry(
        id: '${now.microsecondsSinceEpoch}',
        timestamp: now,
        method: options.method,
        url: options.uri.toString(),
        queryParameters: options.queryParameters.isEmpty ? null : options.queryParameters,
        requestBody: options.data,
        requestHeaders: Map<String, dynamic>.from(options.headers),
        statusCode: response?.statusCode,
        responseBody: response?.data,
        responseHeaders: response == null ? null : _flattenHeaders(response.headers.map),
        errorMessage: error?.message ?? error?.error?.toString(),
        duration: start == null ? null : now.difference(start),
      ),
    );
  }

  Map<String, dynamic> _flattenHeaders(Map<String, List<String>> headers) {
    return headers.map((key, values) => MapEntry(key, values.join('; ')));
  }
}
