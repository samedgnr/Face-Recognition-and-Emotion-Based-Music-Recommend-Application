import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/helper/helper_function.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/play_music_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/services/database_service.dart';
import 'package:music_recommendation_with_emotional_analysiss/snack_bar.dart';

class PlaylistPage extends StatefulWidget {
  final String playlistId;
  const PlaylistPage({Key? key, required this.playlistId}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistPage> {
  String playlistName = "";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.deepPurple.shade800.withOpacity(0.8),
            Colors.deepPurple.shade200.withOpacity(0.8),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Playlist'),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Exit"),
                          content: const Text(
                              "Are you sure you delete the playlist? "),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.deepPurple,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                DatabaseService()
                                    .deletePlaylist(widget.playlistId);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.deepPurple,
                              ),
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.exit_to_app))
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                _PlaylistInformation(playlistName: playlistName),
                const SizedBox(height: 10),
                _PlaylistSongs(playlistId: widget.playlistId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaylistSongs extends StatefulWidget {
  const _PlaylistSongs({
    Key? key,
    required this.playlistId,
  }) : super(key: key);

  final String playlistId;

  @override
  State<_PlaylistSongs> createState() => _PlaylistSongsState();
}

class _PlaylistSongsState extends State<_PlaylistSongs> {
  String playlistName = "";
  String userName = "";
  Stream<QuerySnapshot>? playlist;
  Stream<QuerySnapshot>? songs;
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
      getSongs();
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  getSongs() {
    try {
      DatabaseService().getSongs(widget.playlistId).then((value) {
        setState(() {
          songs = value;
        });
      });
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: songs,
      builder: (context, AsyncSnapshot snapshot) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PlayMusicPage(
                      songName: snapshot.data.docs[index]['songName'],
                      songTrackId: snapshot.data.docs[index]['SongTrackId'],
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 1, left: 10, right: 10),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      "https://media.pinatafarm.com/protected/65CA2375-85F2-4AA2-97D1-499E73E0306D/79989f8e-4bfb-41e1-9ac3-65cac0c6f445-1669494507463-pfarm-with-png-watermarked.webp",
                      //snapshot.data.docs[index]['songIcon'],
                      width: 45,
                    ),
                  ),
                  title: Text(
                    snapshot.data.docs[index]['songName'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    '${snapshot.data.docs[index]['songSinger']} - ${snapshot.data.docs[index]['songDuration']}',
                    style: const TextStyle(color: Colors.white30),
                  ),
                  trailing: GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      Map<String, dynamic> songData = {
                        "songName": snapshot.data.docs[index]['songName'],
                        "songSinger": snapshot.data.docs[index]['songSinger'],
                        "songIcon": snapshot.data.docs[index]['songIcon'],
                        "songDuration": snapshot.data.docs[index]
                            ['songDuration'],
                        "SongTrackId": snapshot.data.docs[index]['SongTrackId'],
                        "SongAddTime": snapshot.data.docs[index]['SongAddTime'],
                        "songId": snapshot.data.docs[index]['songId'],
                      };
                      try {
                        showPopMenu(context, details.globalPosition, playlist!,
                            songData);
                      } catch (e) {
                        Exception(e);
                      }
                    },
                    child: const Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void showPopupMenu(BuildContext context, Offset offset,
      Stream<QuerySnapshot> playlists, Map<String, dynamic> songData) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StreamBuilder<QuerySnapshot>(
          stream: playlists,
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

            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Row(
                    children: [
                      Text(
                        snapshot.data.docs[index]['playlistName'],
                        style: const TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  onTap: () {
                    try {
                      DatabaseService().addSongs(
                          snapshot.data.docs[index]['playlistId'], songData);
                      mySnackBar(context,
                          "${snapshot.data.docs[index]['playlistName']} playlistine ${songData["songName"]} şarkısı eklendi");
                      Navigator.pop(context);
                    } catch (e) {
                      Exception(e);
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  void showPopMenu(BuildContext context, Offset offset,
      Stream<QuerySnapshot> playlists, Map<String, dynamic> songData) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.add),
                title: const Text('Playlist\'e Ekle'),
                onTap: () {
                  Navigator.pop(context);
                  showPopupMenu(context, offset, playlist!, songData);
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove),
                title: const Text('Playlist\'ten Kaldır'),
                onTap: () {
                  try {
                    DatabaseService().deleteSongPlaylist(
                        widget.playlistId, songData["songId"]);
                    mySnackBar(context,
                        " ${songData["songName"]} şarkısı playlistten kaldırıldı.");
                    Navigator.pop(context);
                  } catch (e) {
                    Exception(e);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PlaylistInformation extends StatelessWidget {
  const _PlaylistInformation({
    Key? key,
    required this.playlistName,
  }) : super(key: key);
  final String playlistName;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.network(
            "https://media.pinatafarm.com/protected/65CA2375-85F2-4AA2-97D1-499E73E0306D/79989f8e-4bfb-41e1-9ac3-65cac0c6f445-1669494507463-pfarm-with-png-watermarked.webp",
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.height * 0.3,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          playlistName,
          style: const TextStyle(
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}
