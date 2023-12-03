import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/services/database_service.dart';

class AddSong extends StatefulWidget {
  const AddSong({super.key});

  @override
  State<AddSong> createState() => _AddSongState();
}

class _AddSongState extends State<AddSong> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: addSong(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return const Text('Playlist oluşturuldu!');
        } else if (snapshot.hasError) {
          // Hata durumunda buraya gelir
          return Text('Hata oluştu: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  addSong() {
    Map<String, dynamic> songData = {
      "songName": "Dünyanın Sonuna Doğmuşum",
      "songSinger": "Manga",
      "songIcon": "example_icon_url",
      "songDuration": "04:45",
      "SongTrackId": "2AlPvpsWlG7dEfhfNf9qJR",
      "SongAddTime": FieldValue.serverTimestamp(),
    };

    DatabaseService().addSongs("WNHg12O3pIw46qM4V0qi", songData);
  }
}
