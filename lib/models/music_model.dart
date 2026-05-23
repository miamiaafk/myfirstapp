class Music {
  final String id;
  final String title;
  final String artist;
  final String album;
  final String filePath;
  final String? albumArtPath;
  final int duration;
  final String format;
  final bool isEncrypted;
  final String? encryptedFormat;
  final String? lrcPath;

  Music({
    required this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.filePath,
    this.albumArtPath,
    required this.duration,
    required this.format,
    this.isEncrypted = false,
    this.encryptedFormat,
    this.lrcPath,
  });

  bool get isNcm => format.toLowerCase() == 'ncm';
  bool get isKgm => format.toLowerCase() == 'kgm';
  bool get isPlayable => !isEncrypted || format == 'mp3' || format == 'flac' || format == 'wav' || format == 'm4a';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'filePath': filePath,
      'albumArtPath': albumArtPath,
      'duration': duration,
      'format': format,
      'isEncrypted': isEncrypted,
      'encryptedFormat': encryptedFormat,
      'lrcPath': lrcPath,
    };
  }

  factory Music.fromMap(Map<String, dynamic> map) {
    return Music(
      id: map['id'] as String,
      title: map['title'] as String,
      artist: map['artist'] as String,
      album: map['album'] as String,
      filePath: map['filePath'] as String,
      albumArtPath: map['albumArtPath'] as String?,
      duration: map['duration'] as int,
      format: map['format'] as String,
      isEncrypted: map['isEncrypted'] as bool? ?? false,
      encryptedFormat: map['encryptedFormat'] as String?,
      lrcPath: map['lrcPath'] as String?,
    );
  }

  Music copyWith({
    String? id,
    String? title,
    String? artist,
    String? album,
    String? filePath,
    String? albumArtPath,
    int? duration,
    String? format,
    bool? isEncrypted,
    String? encryptedFormat,
    String? lrcPath,
  }) {
    return Music(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      filePath: filePath ?? this.filePath,
      albumArtPath: albumArtPath ?? this.albumArtPath,
      duration: duration ?? this.duration,
      format: format ?? this.format,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      encryptedFormat: encryptedFormat ?? this.encryptedFormat,
      lrcPath: lrcPath ?? this.lrcPath,
    );
  }
}
