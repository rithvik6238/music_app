class JamendoTrack {
  final String id;
  final String name;
  final String artistId;
  final String artistName;
  final String albumName;
  final String albumId;
  final String audioUrl;
  final String coverUrl;
  final String duration;
  final String licenseCcUrl;

  JamendoTrack({
    required this.id,
    required this.name,
    required this.artistId,
    required this.artistName,
    required this.albumName,
    required this.albumId,
    required this.audioUrl,
    required this.coverUrl,
    required this.duration,
    required this.licenseCcUrl,
  });

  factory JamendoTrack.fromJson(Map<String, dynamic> json) {
    return JamendoTrack(
      id: json['id'] as String,
      name: json['name'] as String,
      artistId: json['artist_id'] as String,
      artistName: json['artist_name'] as String,
      albumName: json['album_name'] as String,
      albumId: json['album_id'] as String,
      audioUrl: json['audio'] as String,
      coverUrl: json['image'] as String,
      duration: json['duration'].toString(),
      licenseCcUrl: json['license_ccurl'] as String,
    );
  }
}
