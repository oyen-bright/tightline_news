/// The publication that published a [NewsArticle].
class ArticleSource {
  const ArticleSource({this.id = '', this.name = ''});

  final String id;
  final String name;

  factory ArticleSource.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return ArticleSource(
        id: (json['id'] ?? '') as String,
        name: (json['name'] ?? '') as String,
      );
    }
    if (json is String) return ArticleSource(name: json);
    return const ArticleSource();
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}

/// A single news article returned by the API.
class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.source = const ArticleSource(),
    this.author = '',
    this.timeAgo = '',
    this.publishedAt,
    this.content = '',
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final ArticleSource source;
  final String author;
  final String timeAgo;
  final DateTime? publishedAt;
  final String content;

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    final publishedAt = DateTime.tryParse(
      (json['publishedAt'] ?? '') as String,
    );

    return NewsArticle(
      id: (json['url'] ?? json['publishedAt'] ?? json['title'] ?? '') as String,
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      imageUrl: (json['urlToImage'] ?? json['imageUrl'] ?? '') as String,
      source: ArticleSource.fromJson(json['source']),
      author: (json['author'] ?? '') as String,
      publishedAt: publishedAt,
      timeAgo: (json['timeAgo'] as String?) ?? _formatTimeAgo(publishedAt),
      content: (json['content'] ?? json['description'] ?? '') as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'source': source.toJson(),
      'author': author,
      'timeAgo': timeAgo,
      'publishedAt': publishedAt?.toIso8601String(),
      'content': content,
    };
  }

  static String _formatTimeAgo(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${(diff.inDays / 7).floor()}w ago';
  }
}
