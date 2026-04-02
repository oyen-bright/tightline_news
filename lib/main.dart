import 'package:flutter/material.dart';
import 'package:tightline_news/app/app.dart';
import 'package:tightline_news/core/config/app_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();
  runApp(const App());
}
