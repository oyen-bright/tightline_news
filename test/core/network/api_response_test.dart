import 'package:flutter_test/flutter_test.dart';
import 'package:tightline_news/core/network/api_response.dart';

void main() {
  group('ApiResponse', () {
    ApiResponse<Map<String, dynamic>> parse(Map<String, dynamic> json) =>
        ApiResponse<Map<String, dynamic>>.fromJson(
          json,
          (p) => p as Map<String, dynamic>,
        );

    test('status "ok" is success', () {
      final r = parse({'status': 'ok', 'message': ''});
      expect(r.isSuccess, isTrue);
    });

    test('status true is success', () {
      final r = parse({'status': true, 'message': ''});
      expect(r.isSuccess, isTrue);
    });

    test('status 200 (int) is success', () {
      final r = parse({'status': 200, 'message': ''});
      expect(r.isSuccess, isTrue);
    });

    test('status "error" is not success', () {
      final r = parse({'status': 'error', 'message': 'Something failed'});
      expect(r.isSuccess, isFalse);
      expect(r.message, 'Something failed');
    });

    test('isRateLimited when httpStatus is 429', () {
      final r = ApiResponse<void>(
        status: false,
        message: 'rate limited',
        httpStatus: 429,
      );
      expect(r.isRateLimited, isTrue);
    });

    test('data falls back to whole body when no data key', () {
      final r = parse({'status': 'ok', 'message': '', 'totalResults': 10});
      expect(r.data?['totalResults'], 10);
    });
  });
}
