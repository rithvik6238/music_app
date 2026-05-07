import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../audio_player/presentation/mini_player.dart';
import '../../audio_player/application/audio_player_controller.dart';
import '../data/jamendo_service.dart';
import '../domain/jamendo_track.dart';

final topTracksProvider = FutureProvider<List<JamendoTrack>>((ref) async {
  final jamendoService = ref.read(jamendoServiceProvider);
  return jamendoService.getTracks(limit: 20);
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topTracksAsyncValue = ref.watch(topTracksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
        actions: [
          IconButton(
            icon: const Icon(Symbols.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: topTracksAsyncValue.when(
              data: (tracks) {
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80), // Space for mini player
                  itemCount: tracks.length,
                  itemBuilder: (context, index) {
                    final track = tracks[index];
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          track.coverUrl,
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Symbols.music_note, size: 48),
                        ),
                      ),
                      title: Text(track.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text(track.artistName, maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: IconButton(
                        icon: const Icon(Symbols.play_arrow),
                        onPressed: () {
                          ref.read(audioPlayerControllerProvider).playTrack(track);
                        },
                      ),
                      onTap: () {
                        ref.read(audioPlayerControllerProvider).playTrack(track);
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      bottomSheet: const MiniPlayer(),
    );
  }
}
