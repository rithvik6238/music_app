import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/playlist.dart';

final libraryRepositoryProvider = Provider((ref) {
  return LibraryRepository(Supabase.instance.client);
});

class LibraryRepository {
  final SupabaseClient _supabase;

  LibraryRepository(this._supabase);

  String? get _userId => _supabase.auth.currentUser?.id;

  // Favorites
  Future<void> addFavorite(String trackId) async {
    if (_userId == null) return;
    await _supabase.from('favorites').insert({
      'user_id': _userId,
      'track_id': trackId,
    });
  }

  Future<void> removeFavorite(String trackId) async {
    if (_userId == null) return;
    await _supabase
        .from('favorites')
        .delete()
        .match({'user_id': _userId!, 'track_id': trackId});
  }

  Future<List<String>> getFavorites() async {
    if (_userId == null) return [];
    final response = await _supabase
        .from('favorites')
        .select('track_id')
        .eq('user_id', _userId!);

    return (response as List).map((row) => row['track_id'] as String).toList();
  }

  // Playlists
  Future<List<Playlist>> getPlaylists() async {
    if (_userId == null) return [];
    final response = await _supabase
        .from('playlists')
        .select()
        .eq('user_id', _userId!)
        .order('created_at', ascending: false);

    return (response as List).map((row) => Playlist.fromJson(row)).toList();
  }

  Future<void> createPlaylist(String name, {String? description}) async {
    if (_userId == null) return;
    await _supabase.from('playlists').insert({
      'user_id': _userId,
      'name': name,
      'description': description,
    });
  }

  Future<void> deletePlaylist(String playlistId) async {
    await _supabase.from('playlists').delete().eq('id', playlistId);
  }

  // Playlist Tracks
  Future<void> addTrackToPlaylist(String playlistId, String trackId) async {
    await _supabase.from('playlist_tracks').insert({
      'playlist_id': playlistId,
      'track_id': trackId,
    });
  }

  Future<void> removeTrackFromPlaylist(String playlistId, String trackId) async {
    await _supabase
        .from('playlist_tracks')
        .delete()
        .match({'playlist_id': playlistId, 'track_id': trackId});
  }

  Future<List<String>> getPlaylistTracks(String playlistId) async {
    final response = await _supabase
        .from('playlist_tracks')
        .select('track_id')
        .eq('playlist_id', playlistId)
        .order('added_at', ascending: true);

    return (response as List).map((row) => row['track_id'] as String).toList();
  }
}
