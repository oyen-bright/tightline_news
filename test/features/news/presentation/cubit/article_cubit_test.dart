import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tightline_news/features/news/domain/entities/article.dart';
import 'package:tightline_news/features/news/domain/repositories/article_repository.dart';
import 'package:tightline_news/features/news/presentation/cubit/article_cubit.dart';
import 'package:tightline_news/features/news/presentation/cubit/article_state.dart';

class _MockArticleRepository extends Mock implements ArticleRepository {}

class _MockStorage extends Mock implements Storage {}

void main() {
  late _MockArticleRepository repository;
  late ArticleCubit cubit;

  setUpAll(() {
    final storage = _MockStorage();
    when(() => storage.write(any(), any<dynamic>())).thenAnswer((_) async {});
    when(() => storage.read(any())).thenReturn(null);
    when(() => storage.delete(any())).thenAnswer((_) async {});
    when(() => storage.clear()).thenAnswer((_) async {});
    HydratedBloc.storage = storage;
  });

  setUp(() {
    repository = _MockArticleRepository();
    cubit = ArticleCubit(repository);
  });

  tearDown(() async => cubit.close());

  NewsArticle article(int i) => NewsArticle(
    id: 'id_$i',
    title: 'Title $i',
    description: 'Description $i',
    imageUrl: 'image_$i',
  );

  test('emits loading then loaded on success', () async {
    when(
      () => repository.getTopHeadlines(page: 1),
    ).thenAnswer((_) async => ([article(1)], 1, null));

    expectLater(
      cubit.stream,
      emitsInOrder([isA<ArticleLoading>(), isA<ArticleLoaded>()]),
    );

    await cubit.loadTopHeadlines();
  });

  test('emits loading then failure on error', () async {
    when(
      () => repository.getTopHeadlines(page: 1),
    ).thenAnswer((_) async => (<NewsArticle>[], 0, 'Too many requests'));

    expectLater(
      cubit.stream,
      emitsInOrder([
        isA<ArticleLoading>(),
        isA<ArticleFailure>().having(
          (s) => s.message,
          'message',
          'Too many requests',
        ),
      ]),
    );

    await cubit.loadTopHeadlines();
  });

  test('silent refresh does not emit loading when already loaded', () async {
    when(
      () => repository.getTopHeadlines(page: 1),
    ).thenAnswer((_) async => ([article(1)], 1, null));
    await cubit.loadTopHeadlines();

    when(
      () => repository.getTopHeadlines(page: 1),
    ).thenAnswer((_) async => ([article(2)], 1, null));

    expectLater(
      cubit.stream,
      emits(
        isA<ArticleLoaded>().having(
          (s) => s.articles.first.title,
          'title',
          'Title 2',
        ),
      ),
    );

    await cubit.loadTopHeadlines();
  });

  test('toJson → fromJson round-trip restores state', () {
    final original = ArticleLoaded(
      articles: [article(1), article(2)],
      totalResults: 20,
      page: 3,
    );
    final restored = cubit.fromJson(cubit.toJson(original)!) as ArticleLoaded;

    expect(restored.articles, hasLength(2));
    expect(restored.totalResults, 20);
    expect(restored.page, 3);
  });

  test(
    'keeps existing articles and sets errorMessage on refresh failure',
    () async {
      when(
        () => repository.getTopHeadlines(page: 1),
      ).thenAnswer((_) async => ([article(1)], 1, null));
      await cubit.loadTopHeadlines();

      when(
        () => repository.getTopHeadlines(page: 1),
      ).thenAnswer((_) async => (<NewsArticle>[], 0, 'Server error'));

      expectLater(
        cubit.stream,
        emits(
          isA<ArticleLoaded>()
              .having((s) => s.articles, 'articles', hasLength(1))
              .having((s) => s.errorMessage, 'errorMessage', 'Server error'),
        ),
      );

      await cubit.loadTopHeadlines();
    },
  );
}
