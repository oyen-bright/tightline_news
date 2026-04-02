import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tightline_news/core/ui/layout/responsive_size.dart';
import 'package:tightline_news/features/news/domain/entities/article.dart';

class TopStoryCard extends StatelessWidget {
  const TopStoryCard({super.key, required this.article, required this.onTap});

  final NewsArticle article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.r(20)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Hero(
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
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  context.w(16),
                  context.h(14),
                  context.w(16),
                  context.h(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (article.source.name.isNotEmpty)
                      Text(
                        article.source.name.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade500,
                          letterSpacing: 1.2,
                        ),
                      ),
                    SizedBox(height: context.h(6)),
                    Expanded(
                      child: Text(
                        article.title,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),
                    ),
                    SizedBox(height: context.h(8)),
                    Row(
                      children: [
                        Text(
                          article.timeAgo,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade500),
                        ),
                        if (article.author.isNotEmpty) ...[
                          Text(
                            '  ·  ',
                            style: TextStyle(color: Colors.grey.shade400),
                          ),
                          Expanded(
                            child: Text(
                              article.author,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey.shade500),
                            ),
                          ),
                        ],
                        Icon(
                          Icons.more_horiz,
                          size: context.r(20),
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
