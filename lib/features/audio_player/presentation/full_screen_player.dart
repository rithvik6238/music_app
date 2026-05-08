import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:audio_service/audio_service.dart';

import '../application/audio_player_controller.dart';
import 'tasl_attribution_sheet.dart';

class FullScreenPlayer extends ConsumerWidget {
  const FullScreenPlayer({super.key});

  String _formatDuration(Duration? duration) {
    if (duration == null) return '0:00';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = duration.inMinutes.remainder(60);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrackState = ref.watch(currentTrackProvider);
    final playbackState = ref.watch(playbackStateProvider);
    final controller = ref.read(audioPlayerControllerProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Symbols.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Now Playing', style: TextStyle(fontSize: 14)),
        actions: [
          IconButton(
            icon: const Icon(Symbols.info),
            onPressed: () {
              if (currentTrackState.value != null) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => TaslAttributionSheet(mediaItem: currentTrackState.value!),
                );
              }
            },
          ),
        ],
      ),
      body: currentTrackState.when(
        data: (mediaItem) {
          if (mediaItem == null) return const Center(child: Text('No track playing'));

          final playing = playbackState.value?.playing ?? false;
          final position = playbackState.value?.updatePosition ?? Duration.zero;
          // Approximate total duration from extras if available, or just use 0
          // In a full implementation, you'd want to expose the stream duration from just_audio
          final totalDuration = mediaItem.duration ?? const Duration(minutes: 3);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (mediaItem.artUri != null)
                  Container(
                    width: MediaQuery.of(context).size.width - 48,
                    height: MediaQuery.of(context).size.width - 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: NetworkImage(mediaItem.artUri!.toString()),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 48),
                Text(
                  mediaItem.title,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  mediaItem.artist ?? 'Unknown Artist',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Slider(
                  value: position.inSeconds.toDouble().clamp(0, totalDuration.inSeconds.toDouble()),
                  max: totalDuration.inSeconds.toDouble(),
                  onChanged: (value) {
                    controller.seek(Duration(seconds: value.toInt()));
                  },
                  activeColor: Colors.white,
                  inactiveColor: Colors.white24,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(position), style: const TextStyle(color: Colors.grey)),
                      Text(_formatDuration(totalDuration), style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: const Icon(Symbols.skip_previous, size: 40),
                      onPressed: () => controller.skipToPrevious(),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: Icon(
                          playing ? Symbols.pause : Symbols.play_arrow,
                          color: Colors.black,
                          size: 48,
                        ),
                        onPressed: () {
                          if (playing) {
                            controller.pause();
                          } else {
                            controller.play();
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Symbols.skip_next, size: 40),
                      onPressed: () => controller.skipToNext(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Error loading track')),
      ),
    );
  }
}
