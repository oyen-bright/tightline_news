import 'package:flutter/material.dart';
import 'package:tightline_news/features/news/domain/entities/article.dart';
import 'package:tightline_news/features/news/presentation/screens/article_detail_screen.dart';
import 'package:tightline_news/features/news/presentation/screens/news_feed_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String articleDetail = '/article-detail';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const NewsFeedScreen(),
        );
      case AppRoutes.articleDetail:
        final args = settings.arguments;
        final article = args is NewsArticle ? args : null;
        if (article == null) {
          return _errorRoute('Missing article for detail screen');
        }
        return PageRouteBuilder(
          settings: settings,
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          pageBuilder: (context, animation, secondaryAnimation) =>
              ArticleDetailScreen(article: article),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        );
      default:
        return _errorRoute('Route not found');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}

