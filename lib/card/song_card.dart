import 'package:flutter/material.dart';

class SongCard extends StatelessWidget {
  final String songName;
  final String songPhoto;
  final String songDuration;
  final String artistName;

  SongCard({
    required this.songName,
    required this.songPhoto,
    required this.songDuration,
    required this.artistName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Image.asset(songPhoto),
        title: Text(songName),
        subtitle: Text('$artistName - $songDuration'),
      ),
    );
  }
}
