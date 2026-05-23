import 'package:flutter/material.dart';
import '../services/audio_player_service.dart';
import 'player_screen.dart';

class MiniPlayerBar extends StatefulWidget {
  const MiniPlayerBar({super.key});

  @override
  State<MiniPlayerBar> createState() => _MiniPlayerBarState();
}

class _MiniPlayerBarState extends State<MiniPlayerBar> {
  final AudioPlayerService _player = AudioPlayerService();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return StreamBuilder<bool>(
      stream: _player.isPlayingStream,
      initialData: false,
      builder: (context, isPlayingSnapshot) {
        return StreamBuilder<dynamic>(
          stream: _player.currentMusicStream,
          builder: (context, musicSnapshot) {
            final isPlaying = isPlayingSnapshot.data ?? false;
            final hasMusic = musicSnapshot.data != null;

            if (!hasMusic) {
              return const SizedBox.shrink();
            }

            return Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (hasMusic) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PlayerScreen(music: musicSnapshot.data!),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.music_note,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  musicSnapshot.data?.title ?? '',
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  musicSnapshot.data?.artist ?? '',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                            onPressed: () {
                              if (isPlaying) {
                                _player.pause();
                              } else {
                                _player.resume();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
