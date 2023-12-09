import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/helper/helper_function.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/play_music_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/playlist_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/profile_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/settings%20page/setting_body.dart';
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
  bool isShowingRecent = true;
  Stream<QuerySnapshot>? likedSongs;

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
      gettingLikedSongs();
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  gettingLikedSongs() async {
    try {
      DatabaseService().getLikedSongs(userId).then((value) {
        setState(() {
          likedSongs = value;
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
            backgroundColor: custom_colors.pinkPrimary,
            title: const Text('SpoCV', style: TextStyle(color: Colors.white)),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white)),
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 290,
                  width: double.infinity,
                  child: Stack(
                    children: [
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
                              offset: const Offset(0, 5),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    child: Text(
                                        'Veri alınamadı: ${snapshot.error}'),
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
                                                    playlistId: snapshot
                                                            .data.docs[index]
                                                        ['playlistId'],
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 40),
                                              padding: const EdgeInsets.all(20),
                                              width: 220,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),

                                                // image: NetworkImage(
                                                //   snapshot.data.docs[index]
                                                //       ['playlistIcon'],
                                                // ),

                                                image: const DecorationImage(
                                                  image: NetworkImage(
                                                    "https://community.spotify.com/t5/image/serverpage/image-id/25294i2836BD1C1A31BDF2/image-size/original?v=mpbl-1&px=-1",
                                                  ),
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
                                                        snapshot.data
                                                                .docs[index]
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
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
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
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 10),
                        child: RotatedBox(
                          quarterTurns: -1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (isShowingRecent == true) {
                                    setState(() {
                                      isShowingRecent = false;
                                    });
                                  }
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 4,
                                      decoration: BoxDecoration(
                                          color: isShowingRecent
                                              ? Colors.transparent
                                              : custom_colors.pinkPrimary,
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      'Liked',
                                      style: TextStyle(
                                          height: 1,
                                          fontSize: 16,
                                          color: isShowingRecent
                                              ? Colors.black54
                                              : Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 32,
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (isShowingRecent == false) {
                                    setState(() {
                                      isShowingRecent = true;
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      width: 10,
                                      height: 4,
                                      decoration: BoxDecoration(
                                          color: isShowingRecent
                                              ? custom_colors.pinkPrimary
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                    ),
                                    const SizedBox(
                                      width: 6,
                                    ),
                                    Text(
                                      'Recent',
                                      style: TextStyle(
                                          height: 1,
                                          fontSize: 16,
                                          color: isShowingRecent
                                              ? Colors.black
                                              : Colors.black54,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0, left: 8),
                          child: StreamBuilder<QuerySnapshot>(
                            stream: likedSongs,
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
                              return ListView.builder(
                                itemCount: isShowingRecent
                                    ? snapshot.data.docs.length
                                    : snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  if (isShowingRecent) {
                                    return const Column(
                                      children: [Text("recent Songs")],
                                    );
                                  } else {
                                    return ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                            height: 52,
                                            width: 52,
                                            child: Image.network(
                                              snapshot.data.docs[index]['songIcon'],
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                      title: Text(
                                        snapshot.data.docs[index]['songName'],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      subtitle: Text(
                                        snapshot.data.docs[index]['songSinger'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      trailing: Text(
                                        snapshot.data.docs[index]['songDuration'],
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ))
                  ],
                )
              ],
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                color: custom_colors.pinkPrimary,
                child: GestureDetector(
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(16, 62, 0, 20),
                    leading: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage('lib/images/noPhoto.jpg'),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          'Profilini Görüntüle',
                          style: TextStyle(
                            color: Color.fromARGB(255, 201, 190, 190),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 6),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.settings),
                    SizedBox(width: 16),
                    Text('Ayarlar'),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsPage(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const Row(
                  children: [
                    Icon(Icons.lock),
                    SizedBox(width: 16),
                    Text('Gizlilik Politikası'),
                  ],
                ),
                onTap: () {},
              ),
            ],
          ),
        ));
  }
}
