import 'dart:io';
import 'package:path/path.dart' as path;
import '../models/music_model.dart';

class MusicScannerService {
  static const List<String> supportedFormats = [
    'mp3',
    'flac',
    'wav',
    'm4a',
    'aac',
    'ogg',
    'ncm',
    'kgm',
  ];

  static const int minDurationSeconds = 60;

  Future<List<Music>> scanDirectory(String directoryPath) async {
    final directory = Directory(directoryPath);
    final musicFiles = <Music>[];

    if (!await directory.exists()) {
      return musicFiles;
    }

    await for (final entity in directory.list(recursive: true)) {
      if (entity is File) {
        final music = await _processFile(entity);
        if (music != null) {
          musicFiles.add(music);
        }
      }
    }

    musicFiles.sort((a, b) => a.title.compareTo(b.title));
    return musicFiles;
  }

  Future<Music?> _processFile(File file) async {
    try {
      final extension = path.extension(file.path).toLowerCase().replaceFirst('.', '');
      
      if (!supportedFormats.contains(extension)) {
        return null;
      }

      final fileName = path.basenameWithoutExtension(file.path);
      final isEncrypted = extension == 'ncm' || extension == 'kgm';

      final lrcPath = await _findLrcFile(file);
      
      int duration = 0;
      String title = fileName;
      String artist = '未知艺术家';
      String album = '未知专辑';

      if (!isEncrypted) {
        try {
          final metadata = await _extractMetadata(file);
          duration = metadata['duration'] ?? 0;
          title = metadata['title'] ?? fileName;
          artist = metadata['artist'] ?? '未知艺术家';
          album = metadata['album'] ?? '未知专辑';
        } catch (e) {
          duration = 0;
        }
      } else {
        duration = 180;
        title = fileName;
      }

      if (duration > 0 && duration < minDurationSeconds) {
        return null;
      }

      return Music(
        id: file.uri.pathSegments.last.hashCode.toString(),
        title: title,
        artist: artist,
        album: album,
        filePath: file.path,
        duration: duration,
        format: extension,
        isEncrypted: isEncrypted,
        encryptedFormat: isEncrypted ? extension : null,
        lrcPath: lrcPath,
      );
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> _extractMetadata(File file) async {
    final metadata = <String, dynamic>{
      'title': path.basenameWithoutExtension(file.path),
      'artist': '未知艺术家',
      'album': '未知专辑',
      'duration': 0,
    };

    try {
      metadata['duration'] = 180;
    } catch (e) {
    }

    return metadata;
  }

  Future<String?> _findLrcFile(File audioFile) async {
    final fileName = path.basenameWithoutExtension(audioFile.path);
    final lrcFiles = [
      '${audioFile.parent.path}/$fileName.lrc',
      '${audioFile.parent.path}/$fileName.lrc',
    ];

    for (final lrcPath in lrcFiles) {
      final lrcFile = File(lrcPath);
      if (await lrcFile.exists()) {
        return lrcPath;
      }
    }

    return null;
  }

  Future<List<String>> getMusicDirectories() async {
    final directories = <String>[];
    
    try {
      final storageDir = Directory('/storage/emulated/0');
      if (await storageDir.exists()) {
        final commonDirs = [
          'Music',
          'Download',
          'Netease/CloudMusic/Download',
          'Kugou',
          'Kuwo',
          'QQMusic',
        ];

        for (final dirName in commonDirs) {
          final dirPath = path.join(storageDir.path, dirName);
          if (await Directory(dirPath).exists()) {
            directories.add(dirPath);
          }
        }
      }
    } catch (e) {
    }

    return directories;
  }
}
