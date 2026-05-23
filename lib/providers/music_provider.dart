import 'package:flutter/foundation.dart';
import '../models/music_model.dart';
import '../services/music_scanner_service.dart';

class MusicProvider with ChangeNotifier {
  final MusicScannerService _scanner = MusicScannerService();
  
  List<Music> _musicList = [];
  List<Music> get musicList => _musicList;
  
  Music? _currentMusic;
  Music? get currentMusic => _currentMusic;
  
  bool _isScanning = false;
  bool get isScanning => _isScanning;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _hasPermission = false;
  bool get hasPermission => _hasPermission;

  Future<void> requestPermission() async {
  }

  Future<void> scanMusic() async {
    _isScanning = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final directories = await _scanner.getMusicDirectories();
      final musicList = <Music>[];

      for (final dir in directories) {
        final scanned = await _scanner.scanDirectory(dir);
        musicList.addAll(scanned);
      }

      final seenIds = <String>{};
      _musicList = musicList.where((music) {
        if (seenIds.contains(music.id)) return false;
        seenIds.add(music.id);
        return true;
      }).toList();

      _isScanning = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isScanning = false;
      notifyListeners();
    }
  }

  void setCurrentMusic(Music music) {
    _currentMusic = music;
    notifyListeners();
  }

  List<Music> getNormalMusic() {
    return _musicList.where((m) => !m.isEncrypted).toList();
  }

  List<Music> getEncryptedMusic() {
    return _musicList.where((m) => m.isEncrypted).toList();
  }
}
