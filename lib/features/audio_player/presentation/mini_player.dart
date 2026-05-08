import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:audio_service/audio_service.dart';

import '../application/audio_player_controller.dart';
import 'full_screen_player.dart';

class MiniPlayer extends ConsumerWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrackState = ref.watch(currentTrackProvider);
    final playbackState = ref.watch(playbackStateProvider);

    return currentTrackState.when(
      data: (mediaItem) {
        if (mediaItem == null) return const SizedBox.shrink();

        final playing = playbackState.value?.playing ?? false;
        final processingState = playbackState.value?.processingState ?? AudioProcessingState.idle;

        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              builder: (context) => const FullScreenPlayer(),
            );
          },
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                if (mediaItem.artUri != null)
                  Image.network(
                    mediaItem.artUri!.toString(),
                    width: 64,
                    height: 64,
                    fit: BoxFit.cover,
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mediaItem.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        mediaItem.artist ?? 'Unknown Artist',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(playing ? Symbols.pause : Symbols.play_arrow),
                  onPressed: () {
                    final controller = ref.read(audioPlayerControllerProvider);
                    if (playing) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
