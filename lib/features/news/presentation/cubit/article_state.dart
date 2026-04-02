import 'package:tightline_news/features/news/domain/entities/article.dart';

sealed class ArticleState {
  const ArticleState();
}

class ArticleInitial extends ArticleState {
  const ArticleInitial();
}

class ArticleLoading extends ArticleState {
  const ArticleLoading();
}

class ArticleLoaded extends ArticleState {
  const ArticleLoaded({
    required this.articles,
    required this.totalResults,
    required this.page,
    this.errorMessage,
  });

  final List<NewsArticle> articles;
  final int totalResults;
  final int page;
  final String? errorMessage;

  bool get hasMore => articles.length < totalResults;

  ArticleLoaded copyWith({
    List<NewsArticle>? articles,
    int? totalResults,
    int? page,
    String? errorMessage,
  }) {
    return ArticleLoaded(
      articles: articles ?? this.articles,
      totalResults: totalResults ?? this.totalResults,
      page: page ?? this.page,
      errorMessage: errorMessage,
    );
  }
}

class ArticleFailure extends ArticleState {
  const ArticleFailure(this.message);

  final String message;
}
