import 'package:flutter/material.dart';
import 'package:tightline_news/core/ui/layout/responsive_size.dart';
import 'package:tightline_news/features/news/presentation/widgets/news_layout_toggle.dart';

class NewsHeader extends StatelessWidget {
  const NewsHeader({
    super.key,
    required this.horizontalPadding,
    required this.isGrid,
    required this.onListSelected,
    required this.onGridSelected,
  });

  final double horizontalPadding;
  final bool isGrid;
  final VoidCallback onListSelected;
  final VoidCallback onGridSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                SizedBox(height: context.h(10)),
              ],
            ),
          ),
          NewsLayoutToggle(
            isGrid: isGrid,
            onListSelected: onListSelected,
            onGridSelected: onGridSelected,
          ),
        ],
      ),
    );
  }
}
