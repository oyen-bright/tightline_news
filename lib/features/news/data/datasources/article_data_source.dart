import 'package:tightline_news/core/network/api_response.dart';

abstract class ArticleDataSource {
  Future<ApiResponse<Map<String, dynamic>>> fetchTopHeadlines({
    int page = 1,
    int pageSize = 20,
  });
}
