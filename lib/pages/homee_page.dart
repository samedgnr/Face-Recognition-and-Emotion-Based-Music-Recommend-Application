import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/helper/helper_function.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/playlist_page.dart';
import '../models/colors.dart' as custom_colors;
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
    return Stack(
      children: [
        Column(
          children: [
            Container(
              height: 290,
              width: double.infinity,
              child: Stack(
                children: [
                  // Pink 240 container
                  Container(
                    height: 240,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: custom_colors.pinkPrimary,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                  ),

                  // Playlist
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Your Playlists',
                                    style: TextStyle(
                                      height: 1,
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Icon(
                                    Icons.collections_bookmark_rounded,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: playlist,
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child:
                                    Text('Veri alınamadı: ${snapshot.error}'),
                              );
                            }

                            if (!snapshot.hasData ||
                                snapshot.data.docs.isEmpty) {
                              return const Center(
                                child: Text('Veri bulunamadı.'),
                              );
                            }

                            return Expanded(
                              flex: 6,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PlaylistPage(
                                                playlistId: snapshot.data
                                                    .docs[index]['playlistId'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 40),
                                          padding: const EdgeInsets.all(20),
                                          width: 220,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: const DecorationImage(
                                                image: AssetImage("lib/images/aa.png"),
                                              // image: NetworkImage(
                                              //   snapshot.data.docs[index]
                                              //       ['playlistIcon'],
                                              // ),
                                              fit: BoxFit.cover,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 5,
                                                offset: Offset(0, 5),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              const Spacer(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    snapshot.data.docs[index]
                                                        ['playlistName'],
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 24,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: const Center(
                                                      child: Icon(
                                                        Icons
                                                            .play_arrow_rounded,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ));
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            // Expanded(
            //   child: SongList(),
            // )
          ],
        ),
      ],
    );
  }
}
