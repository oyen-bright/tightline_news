import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:tightline_news/core/config/app_config.dart';

import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

@lazySingleton
class DioClient {
  DioClient(
    LoggingInterceptor loggingInterceptor,
    ErrorInterceptor errorInterceptor,
  ) : _dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          responseType: ResponseType.json,
        ),
      ) {
    _dio.interceptors.addAll([loggingInterceptor, errorInterceptor]);
  }

  final Dio _dio;

  Dio get raw => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
