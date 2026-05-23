# NCM 音乐播放器

基于 Flutter 的本地音乐播放器，支持识别和标注加密音乐文件。

## 功能特点

- 🔍 本地音乐自动扫描
- 📁 支持 MP3、FLAC、WAV、M4A 等格式
- 🔒 识别并标注 NCM、KGM 加密音乐
- 🎵 完整的音乐播放控制
- 🎨 Material Design 3 深色主题
- 📱 适配 Android 13+ 新权限

## 技术栈

- **框架**: Flutter 3.0+
- **语言**: Dart
- **音频**: just_audio + audio_service
- **状态管理**: Provider
- **权限**: permission_handler

## 快速开始

### 环境要求

- Flutter 3.0+
- Dart 3.0+
- Android SDK 33+
- JDK 11+

### 安装步骤

1. 安装 Flutter SDK: https://flutter.dev/docs/get-started/install

2. 克隆项目（或下载项目代码）:
```bash
cd flutter_player
```

3. 安装依赖:
```bash
flutter pub get
```

4. 运行项目:
```bash
flutter run
```

## 打包 APK

### Debug 版本（用于测试）

```bash
flutter build apk --debug
```

APK 位置: `build/app/outputs/apk/debug/app-debug.apk`

### Release 版本（发布版本）

```bash
flutter build apk --release
```

APK 位置: `build/app/outputs/apk/release/app-release.apk`

### 打包说明

如果需要签名打包 Release 版本，请参考 Flutter 官方文档:
https://docs.flutter.dev/deployment/android

## 使用说明

1. 首次启动应用时，授权存储权限
2. 点击"扫描"按钮扫描本地音乐
3. 点击普通音乐文件直接播放
4. 点击加密音乐文件会提示使用对应官方播放器

## 项目结构

```
lib/
├── main.dart                      # 应用入口
├── models/
│   └── music_model.dart           # 音乐数据模型
├── providers/
│   └── music_provider.dart        # 状态管理
├── screens/
│   ├── home_screen.dart           # 首页
│   └── player_screen.dart         # 播放页
├── services/
│   ├── music_scanner_service.dart # 音乐扫描
│   └── audio_player_service.dart  # 音频播放
└── widgets/
    ├── music_list_item.dart       # 音乐列表项
    └── mini_player_bar.dart       # 迷你播放条

android/
└── app/src/main/
    ├── AndroidManifest.xml        # 清单文件（权限配置）
    └── res/
        └── values/
```

## 权限说明

```xml
<!-- Android 13+ 音频权限 -->
<uses-permission android:name="android.permission.READ_MEDIA_AUDIO" />

<!-- 兼容旧版本存储权限 -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />

<!-- 前台播放服务 -->
<uses-permission android:name="android.permission.FOREGROUND_SERVICE" />
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
```

## 注意事项

- ⚠️ 本应用仅识别加密音乐，不提供解密功能
- 🔐 加密音乐需要使用对应官方播放器（网易云/酷狗）
- 📱 仅支持 Android 平台（目前）

## License

本项目仅供学习使用。
