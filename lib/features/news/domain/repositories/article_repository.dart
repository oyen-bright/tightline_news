import 'package:tightline_news/features/news/domain/entities/article.dart';

abstract class ArticleRepository {
  Future<
    (
      List<NewsArticle> articles,
      int totalResults,
      String? error,
      bool isRateLimited,
    )
  >
  getTopHeadlines({int page = 1});
}
