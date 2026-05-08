class Playlist {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final String? coverUrl;
  final DateTime createdAt;

  Playlist({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.coverUrl,
    required this.createdAt,
  });

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      coverUrl: json['cover_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
