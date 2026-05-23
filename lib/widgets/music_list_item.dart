import 'package:flutter/material.dart';
import '../models/music_model.dart';

class MusicListItem extends StatelessWidget {
  final Music music;
  final VoidCallback? onTap;

  const MusicListItem({
    super.key,
    required this.music,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: music.isEncrypted
              ? colorScheme.errorContainer
              : colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          music.isEncrypted
              ? Icons.lock_outline
              : Icons.music_note,
          color: music.isEncrypted
              ? colorScheme.onErrorContainer
              : colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(
        music.title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: music.isEncrypted ? Colors.grey[400] : null,
        ),
      ),
      subtitle: Text(
        '${music.artist} - ${music.album}',
        style: TextStyle(
          color: Colors.grey[500],
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          music.format.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSecondaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
