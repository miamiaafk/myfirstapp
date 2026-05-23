import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../providers/music_provider.dart';
import '../models/music_model.dart';
import '../widgets/music_list_item.dart';
import '../widgets/mini_player_bar.dart';
import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _requestPermissions();
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.audio.request();
    if (status.isGranted) {
      if (!mounted) return;
      context.read<MusicProvider>().scanMusic();
    }
  }

  void _onMusicTap(Music music) {
    if (music.isEncrypted) {
      _showEncryptedDialog(music);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PlayerScreen(music: music)),
      );
    }
  }

  void _showEncryptedDialog(Music music) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(music.format.toUpperCase()),
        content: Text(
          '这是一首加密音乐\n请使用 ${music.isNcm ? "网易云音乐" : "酷狗音乐"} 播放',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NCM 音乐播放器'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<MusicProvider>().scanMusic(),
          ),
        ],
      ),
      body: Consumer<MusicProvider>(
        builder: (context, provider, _) {
          if (provider.isScanning) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('正在扫描音乐...'),
                ],
              ),
            );
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.errorMessage!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.scanMusic(),
                    child: const Text('重试'),
                  ),
                ],
              ),
            );
          }

          if (provider.musicList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note,
                    size: 80,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '没有找到音乐',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => provider.scanMusic(),
                    child: const Text('扫描'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: provider.musicList.length,
                  itemBuilder: (context, index) {
                    final music = provider.musicList[index];
                    return MusicListItem(
                      music: music,
                      onTap: () => _onMusicTap(music),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const MiniPlayerBar(),
    );
  }
}
