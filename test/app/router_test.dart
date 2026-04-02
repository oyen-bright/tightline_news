import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tightline_news/app/router.dart';
import 'package:tightline_news/features/news/domain/entities/article.dart';

void main() {
  group('AppRouter.generateRoute', () {
    test('home route returns a route', () {
      final route = AppRouter.generateRoute(
        const RouteSettings(name: AppRoutes.home),
      );
      expect(route, isA<Route>());
    });

    test('articleDetail with valid article returns PageRouteBuilder', () {
      const article = NewsArticle(
        id: 'test-id',
        title: 'Test Article',
        description: 'Test description',
        imageUrl: 'https://example.com/image.jpg',
      );
      final route = AppRouter.generateRoute(
        const RouteSettings(name: AppRoutes.articleDetail, arguments: article),
      );
      expect(route, isA<PageRouteBuilder>());
    });

    test('articleDetail without article returns error route', () {
      final route = AppRouter.generateRoute(
        const RouteSettings(name: AppRoutes.articleDetail),
      );
      expect(route, isA<MaterialPageRoute>());
    });

    test('articleDetail with wrong argument type returns error route', () {
      final route = AppRouter.generateRoute(
        const RouteSettings(
          name: AppRoutes.articleDetail,
          arguments: 'not-an-article',
        ),
      );
      expect(route, isA<MaterialPageRoute>());
    });

    test('unknown route returns error route', () {
      final route = AppRouter.generateRoute(
        const RouteSettings(name: '/does-not-exist'),
      );
      expect(route, isA<MaterialPageRoute>());
    });
  });
}
