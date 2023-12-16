import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/helper/helper_function.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/play_music_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/services/database_service.dart';
import 'package:music_recommendation_with_emotional_analysiss/snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../models/colors.dart' as custom_colors;

class PlaylistPage extends StatefulWidget {
  final String playlistId;
  const PlaylistPage({Key? key, required this.playlistId}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistPage> {
  String playlistName = "";

  @override
  void initState() {
    super.initState();
    gettingPlaylistName();
  }

  gettingPlaylistName() async {
    try {
      DatabaseService().getPlaylistName(widget.playlistId).then((value) {
        setState(() {
          playlistName = value;
        });
      });
    } catch (e) {
      print("Hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            custom_colors.pinkPrimary.withOpacity(0.8),
            const Color.fromARGB(255, 163, 137, 211).withOpacity(0.8),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            playlistName,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Delete"),
                          content: const Text(
                              "Are you sure you delete the playlist? "),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: custom_colors.pinkPrimary,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                DatabaseService()
                                    .deletePlaylist(widget.playlistId);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.done,
                                color: custom_colors.pinkPrimary,
                              ),
                            ),
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.exit_to_app))
          ],
          iconTheme: const IconThemeData(color: Colors.white),
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
            bool isLiked =
                snapshot.data.docs[index]['songisLiked'] ? true : false;
            Map<String, dynamic> songData = {
              "songName": snapshot.data.docs[index]['songName'],
              "songSinger": snapshot.data.docs[index]['songSinger'],
              "songIcon": snapshot.data.docs[index]['songIcon'],
              "songDuration": snapshot.data.docs[index]['songDuration'],
              "SongTrackId": snapshot.data.docs[index]['SongTrackId'],
              "SongAddTime": snapshot.data.docs[index]['SongAddTime'],
              "songId": snapshot.data.docs[index]['songId'],
              "songisLiked": snapshot.data.docs[index]['songisLiked'],
            };
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
                      snapshot.data.docs[index]['songIcon'],
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          DatabaseService().updateIsLiked(
                            widget.playlistId,
                            snapshot.data.docs[index]['songId'],
                            !isLiked,
                            userId,
                            songData,
                          );
                          setState(() {
                            snapshot.data.docs[index]['songisLiked'] = !isLiked;
                          });
                        },
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          try {
                            showPopMenu(context, details.globalPosition,
                                playlist!, songData);
                          } catch (e) {
                            Exception(e);
                          }
                        },
                        child: const Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a playlist",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (val) {
                      setState(() {
                        playlistName = val;
                      });
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: custom_colors.buttonColor),
                            borderRadius: BorderRadius.circular(20)),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: custom_colors.buttonColor),
                            borderRadius: BorderRadius.circular(20)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20))),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: custom_colors.buttonColor),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (playlistName != "") {
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createPlaylist(
                              userName,
                              FirebaseAuth.instance.currentUser!.uid,
                              playlistName);
                      Navigator.of(context).pop();
                      showTopSnackBar(
                        Overlay.of(context),
                        const CustomSnackBar.info(
                            message: "Playlist created successfully."),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: custom_colors.buttonColor),
                  child: const Text("CREATE"),
                )
              ],
            );
          }));
        });
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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ElevatedButton(
                    onPressed: () {
                      popUpDialog(context);
                    },
                    child: Text(
                      'Playlist Oluştur',
                      style: TextStyle(color: custom_colors.buttonColor),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
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
                                snapshot.data.docs[index]['playlistId'],
                                songData);
                            showTopSnackBar(
                              Overlay.of(context),
                              CustomSnackBar.success(
                                  message:
                                      "${songData["songName"]} has added to ${snapshot.data.docs[index]['playlistName']} successfully"),
                            );

                            Navigator.pop(context);
                          } catch (e) {
                            Exception(e);
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
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

                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.success(
                          message:
                              "${songData["songName"]} has deleted successfully"),
                    );

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
            "https://community.spotify.com/t5/image/serverpage/image-id/25294i2836BD1C1A31BDF2/image-size/original?v=mpbl-1&px=-1",
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
            color: Colors.white,
            fontSize: 25,
          ),
        ),
      ],
    );
  }
}
