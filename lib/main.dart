import 'package:flutter/material.dart';
import 'package:tightline_news/app/app.dart';
import 'package:tightline_news/core/config/app_config.dart';
import 'package:tightline_news/core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();
  await configureDependencies();
  runApp(const App());
}
