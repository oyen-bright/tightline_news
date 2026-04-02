import 'package:flutter/material.dart';
import 'package:tightline_news/core/ui/layout/responsive_size.dart';

class StatusMessage extends StatelessWidget {
  const StatusMessage.loading({super.key})
    : iconData = null,
      message = 'Loading articles...',
      helperText = null;

  const StatusMessage.error({
    super.key,
    required this.message,
    this.helperText = 'Pull down to try again.',
  }) : iconData = Icons.error_outline;

  const StatusMessage.empty({super.key})
    : iconData = Icons.article_outlined,
      message = 'No articles found.',
      helperText = 'Pull down to refresh.';

  final IconData? iconData;
  final String message;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.w(16),
              vertical: context.h(24),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (iconData != null) ...[
                  Icon(
                    iconData,
                    size: context.r(32),
                    color: Theme.of(context).colorScheme.error,
                  ),
                  SizedBox(height: context.h(12)),
                ] else ...[
                  const CircularProgressIndicator.adaptive(),
                  SizedBox(height: context.h(12)),
                ],
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                if (helperText != null) ...[
                  SizedBox(height: context.h(8)),
                  Text(
                    helperText!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: context.h(8)),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
