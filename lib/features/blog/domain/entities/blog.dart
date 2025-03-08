class Blog {
  final String id;
  final String posterId;
  final String? posterName;
  final String title;
  final String content;
  final String imageUrl;
  final List<String> topics;

  final DateTime updatedAt;

  const Blog({
    required this.id,
    required this.posterId,
    this.posterName,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
    required this.updatedAt,
  });

  @override
  String toString() {
    return 'Blog{id: $id, posterId: $posterId, posterName: $posterName, title: $title, content: $content, imageUrl: $imageUrl, topics: $topics, updatedAt: $updatedAt}';
  }
}
