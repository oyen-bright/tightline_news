import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tightline_news/app/router.dart';
import 'package:tightline_news/core/ui/layout/page_insets.dart';
import 'package:tightline_news/core/ui/layout/responsive_size.dart';
import 'package:tightline_news/core/utils/snackbar_utils.dart';
import 'package:tightline_news/features/news/domain/entities/article.dart';
import 'package:tightline_news/features/news/presentation/cubit/article_cubit.dart';
import 'package:tightline_news/features/news/presentation/cubit/article_state.dart';
import 'package:tightline_news/features/news/presentation/widgets/news_grid_card.dart';
import 'package:tightline_news/features/news/presentation/widgets/news_header.dart';
import 'package:tightline_news/features/news/presentation/widgets/news_list_tile.dart';
import 'package:tightline_news/features/news/presentation/widgets/offline_banner.dart';
import 'package:tightline_news/features/news/presentation/widgets/status_message.dart';
import 'package:tightline_news/features/news/presentation/widgets/top_story_card.dart';

enum _LayoutMode { list, grid }

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  _LayoutMode _layoutMode = _LayoutMode.list;

  void _onArticleTap(NewsArticle article) {
    Navigator.of(
      context,
    ).pushNamed(AppRoutes.articleDetail, arguments: article);
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<ArticleCubit>();
    final state = cubit.state;
    if (state is! ArticleLoaded || !state.hasMore) return;
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - context.h(200)) {
      cubit.loadTopHeadlines(loadMore: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = PageInsets.horizontal(context);

    return BlocListener<ArticleCubit, ArticleState>(
      listener: (context, state) {
        if (state is ArticleLoaded && state.errorMessage != null) {
          SnackbarUtils.showError(context, state.errorMessage!);
        }
      },
      child: Scaffold(
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              NewsHeader(
                horizontalPadding: horizontalPadding,
                isGrid: _layoutMode == _LayoutMode.grid,
                onListSelected: () =>
                    setState(() => _layoutMode = _LayoutMode.list),
                onGridSelected: () =>
                    setState(() => _layoutMode = _LayoutMode.grid),
              ),
              Expanded(
                child: BlocBuilder<ArticleCubit, ArticleState>(
                  builder: (context, state) {
                    List<NewsArticle> topStories;
                    List<NewsArticle> latestNews;
                    List<NewsArticle> allArticles;
                    bool hasMore = false;

                    if (state is ArticleLoaded && state.articles.isNotEmpty) {
                      allArticles = state.articles;
                      topStories = allArticles.take(3).toList();
                      latestNews = allArticles.length > 3
                          ? allArticles.sublist(3)
                          : const [];
                      hasMore = state.hasMore;
                    } else {
                      topStories = [];
                      latestNews = [];
                      allArticles = [];
                    }

                    final child = switch (state) {
                      ArticleLoading() ||
                      ArticleInitial() => const StatusMessage.loading(),
                      ArticleFailure(message: final message) =>
                        StatusMessage.error(message: message),
                      ArticleLoaded() when state.articles.isEmpty =>
                        const StatusMessage.empty(),
                      _ =>
                        _layoutMode == _LayoutMode.list
                            ? _buildListLayout(
                                context,
                                horizontalPadding,
                                topStories,
                                latestNews,
                                hasMore,
                              )
                            : _buildGridLayout(
                                context,
                                horizontalPadding,
                                allArticles,
                                hasMore,
                              ),
                    };

                    return RefreshIndicator.adaptive(
                      onRefresh: () async {
                        await context.read<ArticleCubit>().loadTopHeadlines();
                      },
                      child: child,
                    );
                  },
                ),
              ),

              // Offline banner
              const OfflineBanner(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListLayout(
    BuildContext context,
    double horizontalPadding,
    List<NewsArticle> topStories,
    List<NewsArticle> latestNews,
    bool hasMore,
  ) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              context.h(24),
              horizontalPadding,
              context.h(12),
            ),
            child: Text(
              'Latest headlines',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFFE53935),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: context.h(420),
            child: PageView.builder(
              controller: _pageController,
              itemCount: topStories.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                final article = topStories[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.w(6)),
                  child: TopStoryCard(
                    article: article,
                    onTap: () => _onArticleTap(article),
                  ),
                );
              },
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(top: context.h(12), bottom: context.h(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                topStories.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: context.w(4)),
                  width: _currentPage == i ? context.w(24) : context.w(8),
                  height: context.h(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(context.r(4)),
                    color: _currentPage == i
                        ? const Color(0xFFE53935)
                        : Theme.of(
                            context,
                          ).colorScheme.outlineVariant.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: context.h(8),
            ),
            child: const Divider(),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              context.h(4),
              horizontalPadding,
              context.h(12),
            ),
            child: Text(
              'All articles',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ),

        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverList.separated(
            itemCount: latestNews.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final article = latestNews[index];

              return NewsListTile(
                article: article,
                onTap: () => _onArticleTap(article),
              );
            },
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: context.h(32))),
      ],
    );
  }

  Widget _buildGridLayout(
    BuildContext context,
    double horizontalPadding,
    List<NewsArticle> articles,
    bool hasMore,
  ) {
    final crossAxisCount = ResponsiveSize.valueByWidth<int>(
      context: context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );

    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              context.h(24),
              horizontalPadding,
              context.h(12),
            ),
            child: Text(
              'All Articles',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: const Color(0xFFE53935),
              ),
            ),
          ),
        ),

        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate((context, index) {
              final article = articles[index];
              return NewsGridCard(
                article: article,
                onTap: () => _onArticleTap(article),
              );
            }, childCount: articles.length),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: context.h(12),
              crossAxisSpacing: context.w(12),
              childAspectRatio: 3 / 4.5,
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: context.h(32))),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
