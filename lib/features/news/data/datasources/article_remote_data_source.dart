import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';
import 'package:tightline_news/core/config/app_config.dart';
import 'package:tightline_news/core/network/api_endpoints.dart';
import 'package:tightline_news/core/network/api_response.dart';
import 'package:tightline_news/core/network/dio_client.dart';

@lazySingleton
class ArticleRemoteDataSource {
  ArticleRemoteDataSource(this._client);

  final DioClient _client;

  Future<ApiResponse<Map<String, dynamic>>> fetchTopHeadlines({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      ApiEndpoints.topHeadlines,
      queryParameters: {
        'country': 'us',
        'apiKey': AppConfig.apiKey,
        'page': page,
        'pageSize': pageSize,
      },
    );

    final raw = response.data ?? const <String, dynamic>{};

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      raw,
      (dynamic payload) => payload as Map<String, dynamic>,
    );

    developer.log(
      'fetchTopHeadlines page=$page: '
      'isSuccess=${apiResponse.isSuccess} '
      'dataNull=${apiResponse.data == null} '
      'topKeys=${raw.keys.toList()} '
      'articleCount=${(raw['articles'] as List?)?.length}',
      name: 'ArticleRemoteDataSource',
    );

    return apiResponse;
  }
}
