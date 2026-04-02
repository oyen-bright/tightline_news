import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tightline_news/core/ui/layout/responsive_size.dart';
import 'package:tightline_news/features/news/domain/entities/article.dart';

class NewsListTile extends StatelessWidget {
  const NewsListTile({super.key, required this.article, required this.onTap});

  final NewsArticle article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: context.h(14)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.source.name.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: context.h(4)),
                      child: Text(
                        article.source.name.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade500,
                          letterSpacing: 1.0,
                          fontSize: context.r(10),
                        ),
                      ),
                    ),
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: context.h(4)),
                  Text(
                    article.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: context.h(6)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        article.timeAgo,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade500,
                          fontSize: context.r(11),
                        ),
                      ),
                      if (article.author.isNotEmpty) ...[
                        Text(
                          '  ·  ',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: context.r(11),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            article.author,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.grey.shade500,
                                  fontSize: context.r(11),
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: context.w(14)),
            Hero(
              tag: 'article-image-${article.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(context.r(10)),
                child: SizedBox(
                  width: context.w(100),
                  height: context.w(100),
                  child: article.imageUrl.isEmpty
                      ? Container(
                          color: Colors.grey.shade300,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image_not_supported,
                            size: context.r(24),
                          ),
                        )
                      : CachedNetworkImage(
                          imageUrl: article.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: Colors.grey.shade200),
                          errorWidget: (_, __, ___) => Container(
                            color: Colors.grey.shade300,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.image_not_supported,
                              size: context.r(24),
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
