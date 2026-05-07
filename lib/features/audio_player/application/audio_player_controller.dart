import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audio_service/audio_service.dart';

import '../../../main.dart';
import '../../explore/domain/jamendo_track.dart';
import 'audio_handler.dart';

final audioPlayerControllerProvider = Provider<AudioPlayerController>((ref) {
  return AudioPlayerController(audioHandler);
});

final currentTrackProvider = StreamProvider<MediaItem?>((ref) {
  return audioHandler.mediaItem;
});

final playbackStateProvider = StreamProvider<PlaybackState>((ref) {
  return audioHandler.playbackState;
});

class AudioPlayerController {
  final AudioHandler _audioHandler;

  AudioPlayerController(this._audioHandler);

  Future<void> playTrack(JamendoTrack track) async {
    final mediaItem = MediaItem(
      id: track.audioUrl,
      album: track.albumName,
      title: track.name,
      artist: track.artistName,
      artUri: Uri.parse(track.coverUrl),
      extras: {
        'license_ccurl': track.licenseCcUrl,
      },
    );

    // Using the custom playMediaItem method we added to MyAudioHandler
    if (_audioHandler is MyAudioHandler) {
       await (_audioHandler as MyAudioHandler).playMediaItem(mediaItem);
    }
  }

  Future<void> play() => _audioHandler.play();
  Future<void> pause() => _audioHandler.pause();
  Future<void> seek(Duration position) => _audioHandler.seek(position);
  Future<void> stop() => _audioHandler.stop();
  Future<void> skipToNext() => _audioHandler.skipToNext();
  Future<void> skipToPrevious() => _audioHandler.skipToPrevious();
}
