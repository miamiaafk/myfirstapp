import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import '../models/music_model.dart';

class AudioPlayerService {
  static final AudioPlayerService _instance = AudioPlayerService._internal();
  factory AudioPlayerService() => _instance;
  AudioPlayerService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  // 👇 这里全部修复：seeded → 直接使用构造函数
  final BehaviorSubject<bool> isPlayingSubject = BehaviorSubject(false);
  final BehaviorSubject<double> progressSubject = BehaviorSubject(0.0);
  final BehaviorSubject<Duration> positionSubject = BehaviorSubject(Duration.zero);
  final BehaviorSubject<Duration> durationSubject = BehaviorSubject(Duration.zero);
  final BehaviorSubject<Music?> currentMusicSubject = BehaviorSubject(null);

  List<Music> _playlist = [];
  int _currentIndex = -1;

  AudioPlayer get audioPlayer => _audioPlayer;
  Stream<bool> get isPlayingStream => isPlayingSubject.stream;
  Stream<double> get progressStream => progressSubject.stream;
  Stream<Duration> get positionStream => positionSubject.stream;
  Stream<Duration> get durationStream => durationSubject.stream;
  Stream<Music?> get currentMusicStream => currentMusicSubject.stream;

  bool get isPlaying => isPlayingSubject.value;
  Music? get currentMusic => currentMusicSubject.value;

  Future<void> init() async {
    _audioPlayer.positionStream.listen((position) {
      positionSubject.add(position);
      _updateProgress();
    });

    _audioPlayer.durationStream.listen((duration) {
      durationSubject.add(duration ?? Duration.zero);
      _updateProgress();
    });

    _audioPlayer.playingStream.listen((playing) {
      isPlayingSubject.add(playing);
    });

    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        playNext();
      }
    });
  }

  void _updateProgress() {
    final position = positionSubject.value;
    final duration = durationSubject.value;
    if (duration.inMilliseconds > 0) {
      progressSubject.add(position.inMilliseconds / duration.inMilliseconds);
    }
  }

  Future<void> play(List<Music> playlist, {int index = 0}) async {
    if (index < 0 || index >= playlist.length) return;

    _playlist = playlist;
    _currentIndex = index;
    final music = playlist[index];

    currentMusicSubject.add(music);

    await _audioPlayer.setFilePath(music.filePath);
    await _audioPlayer.play();
  }

  Future<void> playSingle(Music music) async {
    await _audioPlayer.setFilePath(music.filePath);
    await _audioPlayer.play();
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  Future<void> resume() async {
    await _audioPlayer.play();
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Future<void> playNext() async {
    if (_currentIndex + 1 < _playlist.length) {
      await play(_playlist, index: _currentIndex + 1);
    }
  }

  Future<void> playPrevious() async {
    if (_currentIndex - 1 >= 0) {
      await play(_playlist, index: _currentIndex - 1);
    }
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
    isPlayingSubject.close();
    progressSubject.close();
    positionSubject.close();
    durationSubject.close();
    currentMusicSubject.close();
  }
}

class BehaviorSubject<T> {
  final StreamController<T> _controller;
  T _value;

  BehaviorSubject(T initialValue)
      : _value = initialValue,
        _controller = StreamController<T>.broadcast() {
    _controller.onListen = () {
      _controller.add(_value);
    };
  }

  T get value => _value;

  Stream<T> get stream => _controller.stream;

  void add(T value) {
    _value = value;
    _controller.add(value);
  }

  Future<void> close() async {
    await _controller.close();
  }
}
