import 'package:flutter_test/flutter_test.dart';
import 'package:tightline_news/features/news/domain/entities/article.dart';

void main() {
  group('NewsArticle', () {
    test('fromJson parses all fields correctly', () {
      final json = {
        'title': 'Breaking: Flutter 4 Released',
        'description': 'Google announces Flutter 4.',
        'urlToImage': 'https://example.com/image.jpg',
        'source': {'name': 'TechCrunch'},
        'author': 'Jane Doe',
        'publishedAt': '2025-01-15T10:30:00Z',
        'content': 'Full article content here.',
      };

      final article = NewsArticle.fromJson(json);

      expect(article.id, '2025-01-15T10:30:00Z');
      expect(article.title, 'Breaking: Flutter 4 Released');
      expect(article.imageUrl, 'https://example.com/image.jpg');
      expect(article.source.name, 'TechCrunch');
      expect(article.author, 'Jane Doe');
      expect(article.publishedAt, DateTime.utc(2025, 1, 15, 10, 30));
    });

    test('fromJson defaults missing fields to empty strings', () {
      final article = NewsArticle.fromJson(<String, dynamic>{});

      expect(article.title, '');
      expect(article.description, '');
      expect(article.imageUrl, '');
      expect(article.source.name, '');
      expect(article.author, '');
      expect(article.publishedAt, isNull);
    });

    test('toJson serializes fields and round-trips correctly', () {
      const article = NewsArticle(
        id: 'test-id',
        title: 'Title',
        description: 'Description',
        imageUrl: 'image.jpg',
        source: ArticleSource(name: 'Source'),
        author: 'Author',
        timeAgo: '3h ago',
        content: 'Content body',
      );

      final json = article.toJson();

      expect(json['title'], 'Title');
      expect(json['imageUrl'], 'image.jpg');
      expect(json['source'], {'id': '', 'name': 'Source'});
      expect(json['timeAgo'], '3h ago');
    });

    test('timeAgo formats hours correctly', () {
      final json = {
        'title': 'T',
        'description': 'D',
        'urlToImage': 'img',
        'publishedAt': DateTime.now()
            .subtract(const Duration(hours: 5))
            .toIso8601String(),
      };

      expect(NewsArticle.fromJson(json).timeAgo, '5h ago');
    });

    test('fromJson handles invalid publishedAt gracefully', () {
      final json = {
        'title': 'T',
        'description': 'D',
        'urlToImage': 'img',
        'publishedAt': 'not-a-date',
      };

      final article = NewsArticle.fromJson(json);

      expect(article.publishedAt, isNull);
      expect(article.timeAgo, '');
    });
  });
}
