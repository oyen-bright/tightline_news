import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tightline_news/core/network/cubit/network_cubit.dart';
import 'package:tightline_news/core/network/cubit/network_state.dart';
import 'package:tightline_news/features/news/domain/entities/article.dart';
import 'package:tightline_news/features/news/presentation/cubit/article_cubit.dart';
import 'package:tightline_news/features/news/presentation/cubit/article_state.dart';
import 'package:tightline_news/features/news/presentation/screens/news_feed_screen.dart';
import 'package:tightline_news/features/news/presentation/widgets/news_grid_card.dart';
import 'package:tightline_news/features/news/presentation/widgets/news_list_tile.dart';
import 'package:tightline_news/features/news/presentation/widgets/status_message.dart';

class _MockArticleCubit extends Mock implements ArticleCubit {}

class _MockNetworkCubit extends Mock implements NetworkCubit {}

void main() {
  late _MockArticleCubit cubit;
  late _MockNetworkCubit networkCubit;

  NewsArticle article(int i) => NewsArticle(
    id: 'id_$i',
    title: 'Title $i',
    description: 'Description $i',
    imageUrl: 'image_$i',
  );

  Widget buildScreen() => MaterialApp(
    home: MultiBlocProvider(
      providers: [
        BlocProvider<ArticleCubit>.value(value: cubit),
        BlocProvider<NetworkCubit>.value(value: networkCubit),
      ],
      child: const NewsFeedScreen(),
    ),
  );

  setUp(() {
    cubit = _MockArticleCubit();
    networkCubit = _MockNetworkCubit();

    when(() => cubit.stream).thenAnswer((_) => const Stream.empty());
    when(
      () => cubit.state,
    ).thenReturn(ArticleLoaded(articles: [], totalResults: 0, page: 1));
    when(() => cubit.close()).thenAnswer((_) async {});

    when(
      () => networkCubit.state,
    ).thenReturn(const NetworkState(isOnline: true));
    when(() => networkCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => networkCubit.close()).thenAnswer((_) async {});
  });

  tearDown(() {
    cubit.close();
    networkCubit.close();
  });

  testWidgets('shows loading indicator on initial/loading state', (
    tester,
  ) async {
    when(() => cubit.state).thenReturn(const ArticleLoading());
    when(
      () => cubit.stream,
    ).thenAnswer((_) => Stream.value(const ArticleLoading()));

    await tester.pumpWidget(buildScreen());
    await tester.pump();

    expect(find.byType(StatusMessage), findsOneWidget);
  });

  testWidgets('shows empty state when article list is empty', (tester) async {
    final state = ArticleLoaded(articles: [], totalResults: 0, page: 1);
    when(() => cubit.state).thenReturn(state);
    when(() => cubit.stream).thenAnswer((_) => Stream.value(state));

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.byType(StatusMessage), findsOneWidget);
    expect(find.text('No articles found.'), findsOneWidget);
  });

  testWidgets('shows list layout by default', (tester) async {
    final state = ArticleLoaded(
      articles: List.generate(4, article),
      totalResults: 4,
      page: 1,
    );
    when(() => cubit.state).thenReturn(state);
    when(() => cubit.stream).thenAnswer((_) => Stream.value(state));

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.byType(NewsListTile), findsWidgets);
    expect(find.byType(NewsGridCard), findsNothing);
  });

  testWidgets('switches to grid layout on toggle tap', (tester) async {
    final state = ArticleLoaded(
      articles: List.generate(8, article),
      totalResults: 8,
      page: 1,
    );
    when(() => cubit.state).thenReturn(state);
    when(() => cubit.stream).thenAnswer((_) => Stream.value(state));

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.grid_view_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(NewsGridCard), findsWidgets);
  });

  testWidgets('shows error message on failure state', (tester) async {
    const message = 'Too many requests';
    final state = ArticleFailure(message);
    when(() => cubit.state).thenReturn(state);
    when(() => cubit.stream).thenAnswer((_) => Stream.value(state));

    await tester.pumpWidget(buildScreen());
    await tester.pumpAndSettle();

    expect(find.byType(StatusMessage), findsOneWidget);
    expect(find.text(message), findsOneWidget);
  });
}
