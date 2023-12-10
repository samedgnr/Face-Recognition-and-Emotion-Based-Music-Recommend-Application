import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/addsongplaylist.dart';
import 'package:music_recommendation_with_emotional_analysiss/fotograf_gonder.dart';
import 'package:music_recommendation_with_emotional_analysiss/helper/helper_function.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/camera_page.dart';

import 'package:music_recommendation_with_emotional_analysiss/pages/playlist_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/services/database_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = "";
  Stream<QuerySnapshot>? playlist;
  String userId = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
        userId = "${FirebaseAuth.instance.currentUser!.uid}_$userName";
      });
      gettingPlaylist();
    });
  }

  gettingPlaylist() async {
    try {
      DatabaseService().getPlaylists(userId).then((value) {
        setState(() {
          playlist = value;
        });
      });
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hi $userName!"),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraPage()),
                );
              },
              child: const Text("Fotoğraf Çek"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(1.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FotoGonder()),
                );
              },
              child: const Text("Fotoğraf Gönder"),
            ),
          ),

          const Text("My Playlist"),

          StreamBuilder<QuerySnapshot>(
            stream: playlist,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Veri alınamadı: ${snapshot.error}'),
                );
              }

              if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
                return const Center(
                  child: Text('Veri bulunamadı.'),
                );
              }

              return SizedBox(
                height: 210,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaylistPage(
                              playlistId: snapshot.data.docs[index]
                                  ['playlistId'],
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          child: SizedBox(
                            width: 80,
                            height: 150,
                            child: Center(
                              child: Text(
                                snapshot.data.docs[index]['playlistName'],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Add Songs Button
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddSong(),
                ),
              );
            },
            child: const Text("Add Songs"),
          ),
        ],
      ),
    );
  }
}
