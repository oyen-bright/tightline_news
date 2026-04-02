import 'dart:developer' as developer;

import 'package:injectable/injectable.dart';
import 'package:tightline_news/core/network/api_response.dart';
import 'package:tightline_news/features/news/data/datasources/article_data_source.dart';
import 'package:tightline_news/features/news/domain/entities/article.dart';
import 'package:tightline_news/features/news/domain/repositories/article_repository.dart';

/// Fetches articles from the remote data source
@LazySingleton(as: ArticleRepository)
class ArticleRepositoryImpl implements ArticleRepository {
  ArticleRepositoryImpl(this._remote);

  final ArticleDataSource _remote;

  /// Returns articles for [page], totalResults count, optional error string, and rate-limit flag.
  @override
  Future<
    (
      List<NewsArticle> articles,
      int totalResults,
      String? error,
      bool isRateLimited,
    )
  >
  getTopHeadlines({int page = 1}) async {
    try {
      final ApiResponse<Map<String, dynamic>> apiResponse = await _remote
          .fetchTopHeadlines(page: page);

      if (!apiResponse.isSuccess || apiResponse.data == null) {
        developer.log(
          'getTopHeadlines rejected response: isSuccess=${apiResponse.isSuccess} '
          'dataNull=${apiResponse.data == null} '
          'message="${apiResponse.message}"',
          name: 'ArticleRepositoryImpl',
        );
        // Use a friendly message for rate-limit errors (HTTP 429).
        final isRateLimited = apiResponse.isRateLimited;
        final message = isRateLimited
            ? 'Too many requests. Please wait a moment and try again.'
            : apiResponse.message.trim();
        return (
          <NewsArticle>[],
          0,
          message.isNotEmpty ? message : 'Failed to load headlines',
          isRateLimited,
        );
      }

      // Parse the articles array and total count from the response body.
      final data = apiResponse.data!;
      final articlesJson = (data['articles'] as List<dynamic>? ?? [])
          .cast<Map<String, dynamic>>();

      final articles = articlesJson
          .map((a) => NewsArticle.fromJson(a))
          .toList();

      final totalResults =
          (data['totalResults'] as num?)?.toInt() ?? articles.length;

      return (articles, totalResults, null, false);
    } catch (_) {
      return (
        <NewsArticle>[],
        0,
        'Something went wrong. Please try again.',
        false,
      );
    }
  }
}
