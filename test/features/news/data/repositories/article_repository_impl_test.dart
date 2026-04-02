import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tightline_news/core/network/api_response.dart';
import 'package:tightline_news/features/news/data/datasources/article_remote_data_source.dart';
import 'package:tightline_news/features/news/data/repositories/article_repository_impl.dart';

class _MockArticleRemoteDataSource extends Mock
    implements ArticleRemoteDataSource {}

void main() {
  late _MockArticleRemoteDataSource remote;
  late ArticleRepositoryImpl repository;

  setUp(() {
    remote = _MockArticleRemoteDataSource();
    repository = ArticleRepositoryImpl(remote);
  });

  ApiResponse<Map<String, dynamic>> response(Map<String, dynamic> json) =>
      ApiResponse<Map<String, dynamic>>.fromJson(
        json,
        (p) => p as Map<String, dynamic>,
      );

  test('returns articles on success', () async {
    when(() => remote.fetchTopHeadlines(page: any(named: 'page'))).thenAnswer(
      (_) async => response({
        'status': 'ok',
        'totalResults': 2,
        'articles': [
          {'title': 'Title 1', 'description': 'Desc 1', 'urlToImage': 'img1'},
          {'title': 'Title 2', 'description': 'Desc 2', 'urlToImage': 'img2'},
        ],
      }),
    );

    final (articles, totalResults, error) = await repository.getTopHeadlines(
      page: 1,
    );

    expect(error, isNull);
    expect(totalResults, 2);
    expect(articles, hasLength(2));
    expect(articles.first.title, 'Title 1');
  });

  test('returns error message when api reports failure', () async {
    when(() => remote.fetchTopHeadlines(page: any(named: 'page'))).thenAnswer(
      (_) async =>
          response({'status': 'error', 'message': 'Something went wrong'}),
    );

    final (articles, _, error) = await repository.getTopHeadlines(page: 1);

    expect(articles, isEmpty);
    expect(error, 'Something went wrong');
  });

  test('returns friendly message on rate limit (429)', () async {
    when(() => remote.fetchTopHeadlines(page: any(named: 'page'))).thenAnswer(
      (_) async => ApiResponse<Map<String, dynamic>>(
        status: false,
        message: 'You have made too many requests recently.',
        httpStatus: 429,
      ),
    );

    final (articles, _, error) = await repository.getTopHeadlines(page: 1);

    expect(articles, isEmpty);
    expect(error, 'Too many requests. Please wait a moment and try again.');
  });
}
