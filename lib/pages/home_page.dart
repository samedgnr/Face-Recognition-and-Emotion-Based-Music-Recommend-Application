import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/helper/helper_function.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/creat_music_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/play_music_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/playlist_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/profile_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/recomendation%20pages/recommendation_result.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/recomendation%20pages/select_languagee.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/settings%20page/setting_body.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/voice_commands_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/services/music_recommendation_service.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
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
  String playlistName = "";
  String likedPlaylistId = "";

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
                        const CustomSnackBar.success(
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

  void showPopupMenu(
      BuildContext context, Offset offset, Map<String, dynamic> songData) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StreamBuilder<QuerySnapshot>(
          stream: playlist,
          builder: (context, AsyncSnapshot snapshot) {
            print(snapshot.data);
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

  void showPopMenu(
      BuildContext context, Offset offset, Map<String, dynamic> songData) {
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
                  showPopupMenu(context, offset, songData);
                },
              ),
              ListTile(
                leading: const Icon(Icons.remove),
                title: const Text('Playlist\'ten Kaldır'),
                onTap: () {
                  try {
                    // DatabaseService().deleteSongPlaylist(
                    //     widget.playlistId, songData["songId"]);
                    // mySnackBar(context,
                    //     " ${songData["songName"]} şarkısı playlistten kaldırıldı.");
                    // Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: custom_colors.pinkPrimary,
          title: const Text('SpoCV', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          
        ),
        body: SingleChildScrollView(
          child: Column(
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
                                                  playlistId:
                                                      snapshot.data.docs[index]
                                                          ['playlistId'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 40),
                                            padding: const EdgeInsets.all(15),
                                            width: 220,
                                            height: double.infinity,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),

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
                                                  offset: const Offset(0, 2),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(2, 22, 0, 0),
                child: Text(
                  'Music With Your Feelings!',
                  style: TextStyle(
                    fontSize: 24,
                    color: custom_colors.pinkPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 8, 16),
                child: SizedBox(
                  height: 210,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                            width: 180,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SelectLanguagee(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Music Suggestion',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: custom_colors.pinkPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          SizedBox(
                            height: 50,
                            width: 180,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const CreateMusic(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.music_note,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Create Music Ai',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: custom_colors.pinkPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                            width: 180,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const VoiceCommands(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.mic,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Voice Commands',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: custom_colors.pinkPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          SizedBox(
                            height: 50,
                            width: 180,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  Map<String, dynamic> result = 
                                      await EmotionDetectionService
                                          .getRecommendations(
                                    "Neutral",
                                    ["rock"],
                                    ["tame impala"],
                                    "english",
                                  );

                                  if (result.isNotEmpty) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RecommendationResult(
                                          recommendedSongs:
                                              result['recommendations'],
                                          emotion: "Neutral",
                                        ),
                                      ),
                                    );
                                  } else {
                                    print(
                                        'No recommendations found in the result');
                                  }
                                } catch (e) {
                                  print('Error getting recommendations: $e');
                                }
                              },
                              icon: const Icon(
                                Icons.playlist_add,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Neutral Playlist',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: custom_colors.pinkPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SizedBox(
                            height: 50,
                            width: 180,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  Map<String, dynamic> result =
                                      await EmotionDetectionService
                                          .getRecommendations(
                                    "Happy",
                                    ["pop"],
                                    ["tarkan"],
                                    "turkish",
                                  );

                                  if (result.isNotEmpty) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RecommendationResult(
                                          recommendedSongs:
                                              result['recommendations'],
                                          emotion: "Happy",
                                        ),
                                      ),
                                    );
                                  } else {
                                    print(
                                        'No recommendations found in the result');
                                  }
                                } catch (e) {
                                  print('Error getting recommendations: $e');
                                }
                              },
                              icon: const Icon(
                                Icons.playlist_add,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Happy Playlist',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: custom_colors.pinkPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                          SizedBox(
                            height: 50,
                            width: 180,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                try {
                                  Map<String, dynamic> result =
                                      await EmotionDetectionService
                                          .getRecommendations(
                                    "Sad",
                                    ["rock"],
                                    ["duman"],
                                    "turkish",
                                  );

                                  if (result.isNotEmpty) {
                                    // ignore: use_build_context_synchronously
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            RecommendationResult(
                                          recommendedSongs:
                                              result['recommendations'],
                                          emotion: "Sad",
                                        ),
                                      ),
                                    );
                                  } else {
                                    print(
                                        'No recommendations found in the result');
                                  }
                                } catch (e) {
                                  print('Error getting recommendations: $e');
                                }
                              },
                              icon: const Icon(
                                Icons.playlist_add,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'Sad Playlist',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: custom_colors.pinkPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 10, bottom: 870),
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
                                        color: custom_colors.pinkPrimary,
                                        borderRadius: BorderRadius.circular(4)),
                                  ),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  const Text(
                                    'Liked Songs',
                                    style: TextStyle(
                                        height: 1,
                                        fontSize: 16,
                                        color: Colors.black,
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
                    flex: 10,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 36, left: 6),
                      child: StreamBuilder<QuerySnapshot>(
                        stream: likedSongs,
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

                          int itemCount = snapshot.data.docs.length > 8
                              ? 8
                              : snapshot.data.docs.length;

                          return Container(
                            height: 70 * itemCount.toDouble() + 750,
                            child: Column(
                              children: [
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data.docs.length > 8
                                      ? 8
                                      : snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> songData = {
                                      "songName": snapshot.data.docs[index]
                                          ['songName'],
                                      "songSinger": snapshot.data.docs[index]
                                          ['songSinger'],
                                      "songIcon": snapshot.data.docs[index]
                                          ['songIcon'],
                                      "songDuration": snapshot.data.docs[index]
                                          ['songDuration'],
                                      "SongTrackId": snapshot.data.docs[index]
                                          ['SongTrackId'],
                                      "SongAddTime": snapshot.data.docs[index]
                                          ['SongAddTime'],
                                      "songId": snapshot.data.docs[index]
                                          ['songId'],
                                      "songisLiked": snapshot.data.docs[index]
                                          ['songisLiked'],
                                    };

                                    return Container(
                                      height: 70,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PlayMusicPage(
                                                songName: snapshot.data
                                                    .docs[index]['songName'],
                                                songTrackId: snapshot.data
                                                    .docs[index]['SongTrackId'],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              16, 0, 8, 0),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: Image.network(
                                                snapshot.data.docs[index]
                                                    ['songIcon'],
                                                width: 45,
                                              ),
                                            ),
                                            title: Text(
                                              snapshot.data.docs[index]
                                                  ['songName'],
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                            subtitle: Text(
                                              '${snapshot.data.docs[index]['songSinger']} - ${snapshot.data.docs[index]['songDuration']}',
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                            ),
                                            tileColor: Colors.white,
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                GestureDetector(
                                                  onTapDown:
                                                      (TapDownDetails details) {
                                                    try {
                                                      showPopMenu(
                                                          context,
                                                          details
                                                              .globalPosition,
                                                          songData);
                                                    } catch (e) {
                                                      Exception(e);
                                                    }
                                                  },
                                                  child: const Icon(
                                                    Icons.more_horiz,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
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
                    Text('Ayarlar')
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
