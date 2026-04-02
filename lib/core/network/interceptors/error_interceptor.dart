import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@injectable
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    final statusCode = response?.statusCode;

    String message;
    Map<String, dynamic>? responseData;

    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      message = data['message']?.toString() ?? _mapError(err, statusCode);
      final rawData = data['data'];
      if (rawData is Map<String, dynamic>) {
        responseData = rawData;
      }
    } else {
      message = _mapError(err, statusCode);
    }

    final normalizedBody = <String, dynamic>{
      'status': false,
      'message': message,
      'httpStatus': statusCode,
      if (responseData != null) 'data': responseData,
    };

    handler.resolve(
      Response(
        requestOptions: err.requestOptions,
        data: normalizedBody,
        statusCode: statusCode,
        statusMessage: response?.statusMessage,
      ),
    );
  }
}

String _mapError(DioException err, int? statusCode) {
  switch (err.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return 'Network connection error. Please try again.';
    case DioExceptionType.cancel:
      return 'Request was cancelled.';
    case DioExceptionType.badCertificate:
    case DioExceptionType.badResponse:
    case DioExceptionType.unknown:
      return 'Something went wrong. Please try again.';
  }
}
