import 'package:flutter/widgets.dart';
import 'package:tightline_news/core/utils/responsive_size.dart';

/// Shared horizontal insets for top-level screens.
class PageInsets {
  const PageInsets._();

  static double horizontal(BuildContext context) =>
      ResponsiveSize.valueByWidth<double>(
        context: context,
        mobile: context.w(20),
        tablet: context.w(32),
        desktop: context.w(80),
      );
}

