class ApiResponse<T> {
  ApiResponse({
    required this.status,
    required this.message,
    this.data,
    this.httpStatus,
  });

  final bool status;
  final String message;
  final T? data;
  final int? httpStatus;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic)? fromJsonT,
  ) {
    final T? parsedData;
    if (fromJsonT != null) {
      if (json['data'] != null) {
        parsedData = fromJsonT(json['data']);
      } else {
        parsedData = fromJsonT(json);
      }
    } else {
      parsedData = json['data'] as T?;
    }

    return ApiResponse<T>(
      status: _parseStatus(json['status']),
      message: json['message']?.toString() ?? '',
      data: parsedData,
      httpStatus: json['httpStatus'] as int?,
    );
  }

  static bool _parseStatus(dynamic value) {
    if (value is bool) return value;
    if (value is String) return value == 'ok' || value == '200';
    if (value is int) return value == 200;
    return false;
  }

  bool get isSuccess => status;

  bool get isRateLimited => httpStatus == 429 || httpStatus == 426;
}
