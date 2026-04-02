class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.source = '',
    this.author = '',
    this.timeAgo = '',
    this.publishedAt,
    this.content = '',
  });

  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final String author;
  final String timeAgo;
  final DateTime? publishedAt;
  final String content;

  factory NewsArticle.fromJson(Map<String, dynamic> json, {required int index}) {
    final source = (json['source'] as Map<String, dynamic>?)?['name'] ?? '';
    final publishedAt = DateTime.tryParse(json['publishedAt'] ?? '');

    return NewsArticle(
      id: '${json['url'] ?? index}',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      source: source,
      author: json['author'] ?? '',
      publishedAt: publishedAt,
      timeAgo: _formatTimeAgo(publishedAt),
      content: json['content'] ?? json['description'] ?? '',
    );
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

