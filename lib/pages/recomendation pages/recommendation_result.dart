import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/helper/helper_function.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/play_music_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/services/database_service.dart';
import 'package:music_recommendation_with_emotional_analysiss/models/colors.dart'
    as custom_colors;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RecommendationResult extends StatefulWidget {
  final List<dynamic> recommendedSongs;
  final String emotion;
  const RecommendationResult(
      {super.key, required this.recommendedSongs, required this.emotion});

  @override
  State<RecommendationResult> createState() => _RecommendationResultState();
}

class _RecommendationResultState extends State<RecommendationResult> {
  Stream<QuerySnapshot>? playlist;
  String userName = "";
  String userId = "";
  String playlistName = "";
  bool isButtonPressed = false;
  String? myPlaylistId;

  @override
  void initState() {
    gettingUserData();
    super.initState();
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

  void _navigateToHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void addToPlaylist(String playlistId, List<dynamic> recommendedSongs) async {
    for (var song in recommendedSongs) {
      Map<String, dynamic> songData = {
        "songName": song['name'],
        "songSinger": song['artists'],
        "songIcon": song['icon'],
        "songDuration":
            '${song['duration_min'][0]}:${song['duration_min'][1].toString().padLeft(2, '0')}',
        "SongTrackId": song['id'],
        "SongAddTime": FieldValue.serverTimestamp(),
        "songId": "",
        "songisLiked": false,
      };

      await DatabaseService().addSongs(playlistId, songData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _navigateToHome();
        return false; // Prevents default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: custom_colors.pinkPrimary,
          title: Text(
            widget.emotion,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isButtonPressed ? Colors.green : custom_colors.pinkPrimary,
              ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () async {
                  setState(() {
                    isButtonPressed = !isButtonPressed;
                  });

                  if (isButtonPressed) {
                    myPlaylistId = await DatabaseService(
                      uid: FirebaseAuth.instance.currentUser!.uid,
                    ).createPlaylistGetId(
                      userName,
                      FirebaseAuth.instance.currentUser!.uid,
                      widget.emotion,
                    );

                    setState(() {
                      addToPlaylist(myPlaylistId!, widget.recommendedSongs);
                    });
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.success(
                          message: "Playlist created successfully."),
                    );
                  } else {
                    if (myPlaylistId != null) {
                      setState(() {
                        DatabaseService().deletePlaylist(myPlaylistId!);
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.success(
                              message: "Playlist deleted successfully."),
                        );
                      });
                    }
                  }
                },
              ),
            ),
          ],
          elevation: 4,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(14),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(7),
            child: Container(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 2),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.recommendedSongs.length,
                  itemBuilder: (context, index) {
                    final result = widget.recommendedSongs[index];
                    String songDuration =
                        '${result['duration_min'][0]}:${result['duration_min'][1].toString().padLeft(2, '0')}';
                    Map<String, dynamic> songData = {
                      "songName": result['name'],
                      "songSinger": result['artists'],
                      "songIcon": result['icon'],
                      "songDuration": songDuration,
                      "SongTrackId": result['id'],
                      "SongAddTime": "",
                      "songId": "",
                      "songisLiked": false,
                    };
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlayMusicPage(
                              songName: result['name'],
                              songTrackId: result['id'],
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
                              result['icon'],
                              width: 45,
                            ),
                          ),
                          title: Text(
                            result['name'],
                            style: const TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            '${result['artists']} - ${result['duration_min'][0]}:${result['duration_min'][1].toString().padLeft(2, '0')}',
                            style: const TextStyle(
                                color: Color.fromARGB(77, 17, 16, 16)),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GestureDetector(
                                onTapDown: (TapDownDetails details) {
                                  try {
                                    showPopupMenu(
                                        context,
                                        details.globalPosition,
                                        playlist!,
                                        songData);
                                  } catch (e) {
                                    Exception(e);
                                  }
                                },
                                child: Icon(Icons.add,
                                    color: custom_colors.pinkPrimary),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.recommendedSongs.removeAt(index);
                                  });
                                  showTopSnackBar(
                                    Overlay.of(context),
                                    CustomSnackBar.success(
                                        message:
                                            "${result['name']} song has deleted successfully"),
                                  );
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: custom_colors.pinkPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
                                const BorderSide(color: Colors.deepPurple),
                            borderRadius: BorderRadius.circular(20)),
                        errorBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.deepPurple),
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
                      backgroundColor: Colors.deepPurple),
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
                        const CustomSnackBar.success(
                            message: "Playlist created successfully."),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple),
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
                    child: const Text('Playlist Oluştur'),
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
}
