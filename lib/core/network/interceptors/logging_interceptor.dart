import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log(
      '➡️ [${options.method}] ${options.uri}\n'
      'Headers: ${options.headers}\n'
      'Query: ${options.queryParameters}\n'
      'Data: ${options.data}',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      '✅ [${response.requestOptions.method}] ${response.requestOptions.uri}\n'
      'Status: ${response.statusCode}\n'
      'Data: ${response.data}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log(
      '❌ [${err.requestOptions.method}] ${err.requestOptions.uri}\n'
      'Type: ${err.type}\n'
      'Message: ${err.message}\n'
      'Response: ${err.response?.data}',
    );
    super.onError(err, handler);
  }
}

