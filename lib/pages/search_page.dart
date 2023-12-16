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
import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false;
  late List<dynamic> searchResults = [];
  Stream<QuerySnapshot>? playlist;
  String userName = "";
  String userId = "";
  String playlistName = "";

  Future<void> _search() async {
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:5000/search?query=${_searchController.text}'));

    if (response.statusCode == 200) {
      setState(() {
        searchResults = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load search results');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: custom_colors.pinkPrimary,
        title: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: _search,
              icon: const Icon(Icons.search, color: Colors.white),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 2),
            Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final result = searchResults[index];
                  String songDuration =
                      '${result['duration_min'][0]}:${result['duration_min'][1].toString().padLeft(2, '0')}';
                  Map<String, dynamic> songData = {
                    "songName": result['name'],
                    "songSinger": result['artists'][0],
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
                          '${result['artists'][0]} - ${result['duration_min'][0]}:${result['duration_min'][1].toString().padLeft(2, '0')}',
                          style: const TextStyle(
                              color: Color.fromARGB(77, 17, 16, 16)),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                                color: Colors.black,
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
            ],
          ),
        );
      },
    );
  }
}
