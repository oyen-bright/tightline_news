import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:tightline_news/features/news/domain/entities/article.dart';
import 'package:tightline_news/features/news/domain/repositories/article_repository.dart';
import 'package:tightline_news/features/news/presentation/cubit/article_state.dart';

@injectable
class ArticleCubit extends HydratedCubit<ArticleState> {
  ArticleCubit(this._repository) : super(const ArticleInitial());

  final ArticleRepository _repository;
  bool _isLoading = false;
  bool _isLoadingMore = false;

  /// Fetches top headlines.
  /// Pass [loadMore] to append the next page.
  Future<void> loadTopHeadlines({bool loadMore = false}) async {
    if (loadMore) {
      if (_isLoadingMore) return;
    } else {
      if (_isLoading) return;
    }

    if (!loadMore) {
      _isLoading = true;
      final previous = state;

      try {
        // quietly refresh in the background.
        if (previous is ArticleLoaded) {
          final (articles, totalResults, error, _) = await _repository
              .getTopHeadlines(page: 1);
          if (error != null) {
            // Keep existing data, just add error message
            emit(previous.copyWith(errorMessage: error));
          } else {
            emit(
              ArticleLoaded(
                articles: articles,
                totalResults: totalResults,
                page: 1,
              ),
            );
          }
          return;
        }

        // First load or after error: show loading state.
        emit(const ArticleLoading());
        final (articles, totalResults, error, _) = await _repository
            .getTopHeadlines(page: 1);
        if (error != null) {
          emit(ArticleFailure(error));
        } else {
          emit(
            ArticleLoaded(
              articles: articles,
              totalResults: totalResults,
              page: 1,
            ),
          );
        }
      } finally {
        _isLoading = false;
      }
      return;
    }

    _isLoadingMore = true;
    final current = state;
    if (current is! ArticleLoaded || !current.hasMore) {
      _isLoadingMore = false;
      return;
    }

    try {
      final nextPage = current.page + 1;
      final (nextArticles, _, error, isRateLimited) = await _repository
          .getTopHeadlines(page: nextPage);
      if (error != null) {
        // If rate-limited, cap pagination so hasMore becomes false.
        // For other errors, leave hasMore intact so it can be retried.
        emit(
          current.copyWith(
            errorMessage: error,
            totalResults: isRateLimited ? current.articles.length : null,
          ),
        );
        return;
      }

      emit(
        current.copyWith(
          articles: [...current.articles, ...nextArticles],
          page: nextPage,
        ),
      );
    } finally {
      _isLoadingMore = false;
    }
  }

  @override
  Map<String, dynamic>? toJson(ArticleState state) {
    if (state is! ArticleLoaded) return null;
    return {
      'totalResults': state.totalResults,
      'page': state.page,
      'articles': state.articles.map((a) => a.toJson()).toList(),
    };
  }

  @override
  ArticleState? fromJson(Map<String, dynamic> json) {
    try {
      final articlesJson = json['articles'] as List<dynamic>? ?? [];

      final articles = articlesJson
          .whereType<Map<String, dynamic>>()
          .map(NewsArticle.fromJson)
          .toList();

      if (articles.isEmpty) {
        return const ArticleInitial();
      }

      return ArticleLoaded(
        articles: articles,
        totalResults:
            (json['totalResults'] as num?)?.toInt() ?? articles.length,
        page: (json['page'] as num?)?.toInt() ?? 1,
      );
    } catch (e) {
      return const ArticleInitial();
    }
  }
}
