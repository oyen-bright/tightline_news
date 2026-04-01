import 'package:flutter/material.dart';

class AppRoutes {
  static const String home = '/';
  static const String articleDetail = '/article-detail';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Home')),
          ),
        );
      case AppRoutes.articleDetail:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Article Detail')),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Not found')),
          ),
        );
    }
  }
}

