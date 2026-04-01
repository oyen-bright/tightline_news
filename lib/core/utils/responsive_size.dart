import 'package:flutter/widgets.dart';

class ResponsiveSize {
  const ResponsiveSize._();

  // Design size used for scaling (logical pixels).
  static const double designWidth = 390;
  static const double designHeight = 844;

  static double widthOf(BuildContext context) =>
      MediaQuery.sizeOf(context).width;

  static double heightOf(BuildContext context) =>
      MediaQuery.sizeOf(context).height;

  // 600 mobile, 1024 tablet, 1024+ desktop
  static bool isMobile(BuildContext context) => widthOf(context) < 600;

  static bool isTablet(BuildContext context) =>
      widthOf(context) >= 600 && widthOf(context) < 1024;

  static bool isDesktop(BuildContext context) => widthOf(context) >= 1024;

  static T valueByWidth<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }
}

// Extensions to keep layout code concise, using a fixed design size.
extension ResponsiveContextX on BuildContext {
  Size get _size => MediaQuery.sizeOf(this);

  double get _scaleWidth => _size.width / ResponsiveSize.designWidth;

  double get _scaleHeight => _size.height / ResponsiveSize.designHeight;

  double w(num designValue) => designValue * _scaleWidth;

  double h(num designValue) => designValue * _scaleHeight;

  double r(num designValue) {
    final scale = _scaleWidth < _scaleHeight ? _scaleWidth : _scaleHeight;
    return designValue * scale;
  }

  double sp(num designSize) {
    final scaled = designSize * _scaleWidth;
    return MediaQuery.textScalerOf(this).scale(scaled.toDouble());
  }
}
