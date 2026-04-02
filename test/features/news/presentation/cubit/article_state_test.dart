import 'package:flutter_test/flutter_test.dart';
import 'package:tightline_news/features/news/domain/entities/article.dart';
import 'package:tightline_news/features/news/presentation/cubit/article_state.dart';

void main() {
  NewsArticle article(int i) => NewsArticle(
    id: 'id_$i',
    title: 'Title $i',
    description: 'Description $i',
    imageUrl: 'image_$i',
  );

  group('ArticleLoaded', () {
    test('hasMore is true when articles < totalResults', () {
      final state = ArticleLoaded(
        articles: [article(1)],
        totalResults: 10,
        page: 1,
      );
      expect(state.hasMore, isTrue);
    });

    test('hasMore is false when all articles are loaded', () {
      final state = ArticleLoaded(
        articles: [article(1), article(2)],
        totalResults: 2,
        page: 1,
      );
      expect(state.hasMore, isFalse);
    });

    test('copyWith overrides specified values', () {
      final original = ArticleLoaded(
        articles: [article(1)],
        totalResults: 5,
        page: 1,
      );
      final copy = original.copyWith(
        articles: [article(1), article(2)],
        page: 2,
        errorMessage: 'Network error',
      );
      expect(copy.articles, hasLength(2));
      expect(copy.page, 2);
      expect(copy.totalResults, 5);
      expect(copy.errorMessage, 'Network error');
    });

    test('copyWith clears errorMessage when not provided', () {
      final state = ArticleLoaded(
        articles: [article(1)],
        totalResults: 5,
        page: 1,
        errorMessage: 'Previous error',
      );
      expect(state.copyWith().errorMessage, isNull);
    });
  });

  group('ArticleFailure', () {
    test('stores error message', () {
      expect(
        const ArticleFailure('Something went wrong').message,
        'Something went wrong',
      );
    });
  });
}
