import 'package:flutter/material.dart';

class PlaylistCard extends StatelessWidget {
  final String playlistName;
  final String playlistPhoto;
  PlaylistCard(
      {super.key, required this.playlistName, required this.playlistPhoto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          width: 200,
          height: 200,
          child: Center(
            child: Text(playlistName),
          ),
        ),
      ),
    );
  }
}
