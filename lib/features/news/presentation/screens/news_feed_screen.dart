import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tightline_news/app/router.dart';
import 'package:tightline_news/core/utils/responsive_size.dart';
import 'package:tightline_news/core/widgets/page_insets.dart';
import 'package:tightline_news/features/news/domain/news_article.dart';
import 'package:tightline_news/features/news/presentation/widgets/news_grid_card.dart';
import 'package:tightline_news/features/news/presentation/widgets/news_layout_toggle.dart';
import 'package:tightline_news/features/news/presentation/widgets/news_list_tile.dart';
import 'package:tightline_news/features/news/presentation/widgets/top_story_card.dart';

enum _LayoutMode { list, grid }

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.92);
  int _currentPage = 0;
  _LayoutMode _layoutMode = _LayoutMode.list;
  final bool _isOffline = false;

  final List<NewsArticle> _topStories = const [
    NewsArticle(
      id: '1',
      title: 'Markets rally as investors digest latest economic data',
      description:
          'Global markets saw a broad-based rally today as investors reacted to a new set of inflation and employment figures that came in largely in line with expectations.',
      imageUrl:
          'https://images.pexels.com/photos/210607/pexels-photo-210607.jpeg',
      source: 'Reuters',
      author: 'Sarah Chen',
      timeAgo: '12m ago',
    ),
    NewsArticle(
      id: '2',
      title: 'Tech companies double down on AI investments',
      description:
          'Major technology firms announced a new wave of AI-focused initiatives, signalling that competition in the generative AI space is only just beginning.',
      imageUrl:
          'https://images.pexels.com/photos/11813156/pexels-photo-11813156.jpeg',
      source: 'The Verge',
      author: 'Alex Rivera',
      timeAgo: '28m ago',
    ),
    NewsArticle(
      id: '3',
      title: 'Severe weather warnings issued across the region',
      description:
          'Meteorologists have issued severe weather alerts across multiple states as a fast-moving storm system brings heavy rain and strong winds.',
      imageUrl:
          'https://images.pexels.com/photos/1118873/pexels-photo-1118873.jpeg',
      source: 'Weather Channel',
      author: 'Jim Pratt',
      timeAgo: '45m ago',
    ),
  ];

  final List<NewsArticle> _latestNews = const [
    NewsArticle(
      id: '4',
      title:
          'NASA\'s Artemis II rocket launches astronauts on historic moon mission',
      description:
          'Four astronauts lifted off from Kennedy Space Center aboard the Orion spacecraft, marking humanity\'s return to lunar orbit after more than 50 years.',
      imageUrl:
          'https://images.pexels.com/photos/586063/pexels-photo-586063.jpeg',
      source: 'Space News',
      author: 'Emily Torres',
      timeAgo: '1h ago',
    ),
    NewsArticle(
      id: '5',
      title: 'Electric vehicle sales surge to record levels in Q1',
      description:
          'Global electric vehicle sales reached a new quarterly record, driven by strong demand in China and Europe as battery costs continue to fall.',
      imageUrl:
          'https://images.pexels.com/photos/110844/pexels-photo-110844.jpeg',
      source: 'Bloomberg',
      author: 'Marcus Webb',
      timeAgo: '2h ago',
    ),
    NewsArticle(
      id: '6',
      title: 'New study reveals breakthrough in renewable energy storage',
      description:
          'Researchers at MIT have developed a novel battery technology that could make large-scale renewable energy storage significantly more affordable.',
      imageUrl:
          'https://images.pexels.com/photos/356036/pexels-photo-356036.jpeg',
      source: 'MIT Technology Review',
      author: 'Dr. Lisa Chang',
      timeAgo: '3h ago',
    ),
    NewsArticle(
      id: '7',
      title: 'Global coffee prices hit 10-year high amid supply concerns',
      description:
          'Arabica coffee futures surged to their highest level in a decade as adverse weather conditions in Brazil threaten the upcoming harvest.',
      imageUrl:
          'https://images.pexels.com/photos/312418/pexels-photo-312418.jpeg',
      source: 'Financial Times',
      author: 'James Barton',
      timeAgo: '4h ago',
    ),
    NewsArticle(
      id: '8',
      title: 'Major cybersecurity summit addresses rising threat landscape',
      description:
          'World leaders and tech executives convened in Geneva to discuss coordinated responses to increasingly sophisticated cyber threats targeting critical infrastructure.',
      imageUrl:
          'https://images.pexels.com/photos/60504/security-protection-anti-virus-software-60504.jpeg',
      source: 'Wired',
      author: 'Nina Petrov',
      timeAgo: '5h ago',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onArticleTap(NewsArticle article) {
    Navigator.of(
      context,
    ).pushNamed(AppRoutes.articleDetail, arguments: article);
  }

  List<NewsArticle> get _allArticles => [..._topStories, ..._latestNews];

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = PageInsets.horizontal(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: RefreshIndicator(
                onRefresh: () async {
                  await Future<void>.delayed(const Duration(milliseconds: 800));
                  if (!mounted) return;
                  setState(() {});
                },
                child: _layoutMode == _LayoutMode.list
                    ? _buildListLayout(context, horizontalPadding)
                    : _buildGridLayout(context, horizontalPadding),
              ),
            ),
          ),

          // Offline banner
          if (_isOffline)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: context.h(10),
                horizontal: context.w(16),
              ),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: SafeArea(
                top: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: context.r(16),
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    SizedBox(width: context.w(8)),
                    Text(
                      'You are offline',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                        fontSize: context.r(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildListLayout(BuildContext context, double horizontalPadding) {
    return CustomScrollView(
      slivers: [
        _buildHeader(context, horizontalPadding),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              context.h(24),
              horizontalPadding,
              context.h(12),
            ),
            child: Text(
              'Top headlines',
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
              itemCount: _topStories.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                final article = _topStories[index];
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
                _topStories.length,
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
              'Latest News',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
        ),

        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          sliver: SliverList.separated(
            itemCount: _latestNews.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final article = _latestNews[index];
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

  Widget _buildGridLayout(BuildContext context, double horizontalPadding) {
    final crossAxisCount = ResponsiveSize.valueByWidth<int>(
      context: context,
      mobile: 2,
      tablet: 3,
      desktop: 4,
    );
    final articles = _allArticles;

    return CustomScrollView(
      slivers: [
        _buildHeader(context, horizontalPadding),

        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              context.h(24),
              horizontalPadding,
              context.h(12),
            ),
            child: Text(
              'All Stories',
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
              childAspectRatio: 3 / 4,
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: context.h(32))),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, double horizontalPadding) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontalPadding,
          context.h(16),
          horizontalPadding,
          0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.newspaper_rounded,
                        size: context.r(28),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(width: context.w(8)),
                      Text(
                        'News',
                        style: Theme.of(context).textTheme.headlineLarge
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(2)),
                  Text(
                    DateFormat('d MMMM').format(DateTime.now()),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            NewsLayoutToggle(
              isGrid: _layoutMode == _LayoutMode.grid,
              onListSelected: () =>
                  setState(() => _layoutMode = _LayoutMode.list),
              onGridSelected: () =>
                  setState(() => _layoutMode = _LayoutMode.grid),
            ),
          ],
        ),
      ),
    );
  }
}
