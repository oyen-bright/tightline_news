import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tightline_news/core/ui/layout/page_insets.dart';
import 'package:tightline_news/core/ui/layout/responsive_size.dart';
import 'package:tightline_news/features/news/domain/entities/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = PageInsets.horizontal(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: context.h(300),
            pinned: true,
            stretch: true,
            backgroundColor: Theme.of(context).colorScheme.surface,
            leading: Padding(
              padding: EdgeInsets.all(context.r(8)),
              child: CircleAvatar(
                backgroundColor: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.7),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.onSurface,
                    size: context.r(20),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'article-image-${article.id}',
                child: article.imageUrl.isEmpty
                    ? Container(
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image_not_supported,
                          size: context.r(48),
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: article.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            Container(color: Colors.grey.shade200),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image_not_supported,
                            size: context.r(48),
                          ),
                        ),
                      ),
              ),
            ),
          ),

          // Article content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                context.h(24),
                horizontalPadding,
                context.h(40),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.source.name.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: context.h(8)),
                      child: Text(
                        article.source.name.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFE53935),
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: context.h(12)),
                  if (article.author.isNotEmpty || article.timeAgo.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: context.h(20)),
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,

                        children: [
                          if (article.timeAgo.isNotEmpty)
                            Text(
                              article.timeAgo,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey.shade500),
                            ),
                          if (article.author.isNotEmpty &&
                              article.timeAgo.isNotEmpty)
                            Text(
                              '  ·  ',
                              style: TextStyle(color: Colors.grey.shade400),
                            ),
                          if (article.author.isNotEmpty)
                            Text(
                              article.author,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.grey.shade500,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                        ],
                      ),
                    ),
                  const Divider(),
                  SizedBox(height: context.h(16)),
                  Text(
                    article.content,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.7,
                      fontSize: context.r(17),
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
}
