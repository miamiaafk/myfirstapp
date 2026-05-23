import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/music_model.dart';
import '../services/audio_player_service.dart';
import '../providers/music_provider.dart';

class PlayerScreen extends StatefulWidget {
  final Music music;

  const PlayerScreen({super.key, required this.music});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final AudioPlayerService _player = AudioPlayerService();

  @override
  void initState() {
    super.initState();
    _playMusic();
  }

  Future<void> _playMusic() async {
    final provider = context.read<MusicProvider>();
    await _player.play(provider.musicList, index: provider.musicList.indexOf(widget.music));
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: colorScheme.primaryContainer,
                  ),
                  child: Icon(
                    Icons.music_note,
                    size: 120,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      StreamBuilder<Music?>(
                        stream: _player.currentMusicStream,
                        initialData: widget.music,
                        builder: (context, snapshot) {
                          final music = snapshot.data ?? widget.music;
                          return Column(
                            children: [
                              Text(
                                music.title,
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                music.artist,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      color: Colors.grey[400],
                                    ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      StreamBuilder<double>(
                        stream: _player.progressStream,
                        initialData: 0.0,
                        builder: (context, snapshot) {
                          final progress = snapshot.data ?? 0.0;
                          return Column(
                            children: [
                              Slider(
                                value: progress,
                                onChanged: (value) {
                                  final duration = _player.durationSubject.value;
                                  _player.seek(
                                    Duration(milliseconds: (duration.inMilliseconds * value).toInt()),
                                  );
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    StreamBuilder<Duration>(
                                      stream: _player.positionStream,
                                      initialData: Duration.zero,
                                      builder: (context, snapshot) {
                                        return Text(
                                          _formatDuration(snapshot.data ?? Duration.zero),
                                          style: Theme.of(context).textTheme.bodySmall,
                                        );
                                      },
                                    ),
                                    StreamBuilder<Duration>(
                                      stream: _player.durationStream,
                                      initialData: Duration.zero,
                                      builder: (context, snapshot) {
                                        return Text(
                                          _formatDuration(snapshot.data ?? Duration.zero),
                                          style: Theme.of(context).textTheme.bodySmall,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.skip_previous),
                            iconSize: 40,
                            onPressed: () => _player.playPrevious(),
                          ),
                          const SizedBox(width: 24),
                          StreamBuilder<bool>(
                            stream: _player.isPlayingStream,
                            initialData: false,
                            builder: (context, snapshot) {
                              final isPlaying = snapshot.data ?? false;
                              return IconButton.filled(
                                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                                iconSize: 64,
                                padding: const EdgeInsets.all(16),
                                onPressed: () {
                                  if (isPlaying) {
                                    _player.pause();
                                  } else {
                                    _player.resume();
                                  }
                                },
                              );
                            },
                          ),
                          const SizedBox(width: 24),
                          IconButton(
                            icon: const Icon(Icons.skip_next),
                            iconSize: 40,
                            onPressed: () => _player.playNext(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
