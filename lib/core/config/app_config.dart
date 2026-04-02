import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class AppConfig {
  AppConfig._();

  static late String baseUrl;
  static late String apiKey;

  static const String environment = String.fromEnvironment(
    'env',
    defaultValue: 'dev',
  );

  static Future<void> load() async {
    try {
      final yamlString = await rootBundle.loadString('app_config.yaml');
      final yamlMap = loadYaml(yamlString) as YamlMap;

      baseUrl = yamlMap[environment]['baseUrl'] as String;
      apiKey = yamlMap[environment]['apiKey'] as String;

      log('Base URL: $baseUrl');
    } catch (e) {
      throw Exception('Failed to load environment configuration: $e');
    }
  }
}
