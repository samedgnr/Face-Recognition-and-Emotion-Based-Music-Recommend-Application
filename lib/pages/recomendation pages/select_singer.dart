import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/models/colors.dart'
    as custom_colors;
import 'package:music_recommendation_with_emotional_analysiss/pages/recomendation%20pages/take_photo.dart';
import 'package:music_recommendation_with_emotional_analysiss/services/music_recommendation_service.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SelectSinger extends StatefulWidget {
  final List<String> selectedLanguages;
  final List<String> selectedGenres;
  const SelectSinger(
      {super.key,
      required this.selectedLanguages,
      required this.selectedGenres});

  @override
  State<SelectSinger> createState() => _SelectSingerState();
}

class _SelectSingerState extends State<SelectSinger> {
  List<String> availableArtist = [];
  List<String> selectedArtists = [];

  List<Map<String, dynamic>> singerList = [
    {
      'id': '4IJczjB0fJ04gs4uvP0Fli',
      'name': 'Gym Class Heroes',
      'icon':
          'https://i.scdn.co/image/ab6761610000e5eb2b128023b3a465eb11c8d204',
      'followers': 1483853,
    },
    {
      'id': '04gDigrS5kc9YWfZHwBETP',
      'name': 'Maroon 5',
      'icon':
          'https://i.scdn.co/image/ab6761610000e5ebf8349dfb619a7f842242de77',
      'followers': 42006684,
    },
    {
      'id': '1vCWHaC5f2uS3yhpwWbIA6',
      'name': 'Avicii',
      'icon':
          'https://i.scdn.co/image/ab6761610000e5ebae07171f989fb39736674113',
      'followers': 23301041,
    },
    {
      'id': '4IJczjB0fJ04gs4uvP0Fli',
      'name': 'ddsad',
      'icon':
          'https://i.scdn.co/image/ab6761610000e5eb2b128023b3a465eb11c8d204',
      'followers': 1483853,
    },
    {
      'id': '04gDigrS5kc9YWfZHwBETP',
      'name': 'asdasddadas',
      'icon':
          'https://i.scdn.co/image/ab6761610000e5ebf8349dfb619a7f842242de77',
      'followers': 42006684,
    },
    {
      'id': '1vCWHaC5f2uS3yhpwWbIA6',
      'name': 'dsadsaadsads',
      'icon':
          'https://i.scdn.co/image/ab6761610000e5ebae07171f989fb39736674113',
      'followers': 23301041,
    },
    {
      'id': '4IJczjB0fJ04gs4uvP0Fli',
      'name': 'adsadsaddas',
      'icon':
          'https://i.scdn.co/image/ab6761610000e5eb2b128023b3a465eb11c8d204',
      'followers': 1483853,
    },
    {
      'id': '04gDigrS5kc9YWfZHwBETP',
      'name': 'Masd',
      'icon':
          'https://i.scdn.co/image/ab6761610000e5ebf8349dfb619a7f842242de77',
      'followers': 42006684,
    },
    {
      'id': '1vCWHaC5f2uS3yhpwWbIA6',
      'name': 'Adasdaadsdas',
      'icon':
          'https://i.scdn.co/image/ab6761610000e5ebae07171f989fb39736674113',
      'followers': 23301041,
    },
    {
      'id': '1vCWHaC5f2uS3yhpwWbIA6',
      'name': 'dsadsaadsads',
      'icon':
          'https://i.scdn.co/image/ab6761610000e5ebae07171f989fb39736674113',
      'followers': 23301041,
    },
    {
      'id': '4IJczjB0fJ04gs4uvP0Fli',
      'name': 'adsadsaddas',
      'icon':
          'https://i.scdn.co/image/ab6761610000e5eb2b128023b3a465eb11c8d204',
      'followers': 1483853,
    },
    {
      'id': '04gDigrS5kc9YWfZHwBETP',
      'name': 'Masd',
      'icon':
          'https://i.scdn.co/image/ab6761610000e5ebf8349dfb619a7f842242de77',
      'followers': 42006684,
    },
    {
      'id': '1vCWHaC5f2uS3yhpwWbIA6',
      'name': 'Adasdaadsdas',
      'icon':
          'https://i.scdn.co/image/ab6761610000e5ebae07171f989fb39736674113',
      'followers': 23301041,
    },
  ];

  void showSelectedArtistDialog(String selectedArtist) async {
    TextEditingController artistNameController = TextEditingController();
    Map<String, dynamic> artistInfo = {};

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Search Artist',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: custom_colors.pinkPrimary,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: TextField(
                              maxLines: null,
                              controller: artistNameController,
                              onChanged: (value) {
                                setState(() {
                                  selectedArtist = value;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: 'Enter Artist Name',
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.search,
                              color: custom_colors.pinkPrimary),
                          onPressed: () async {
                            try {
                              final result =
                                  await EmotionDetectionService.getArtistInfo(
                                      selectedArtist);
                              setState(() {
                                artistInfo = result;
                              });
                              print(artistInfo);
                            } catch (e) {
                              print('Error fetching artist info: $e');
                            }
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 30, 8, 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: artistInfo.isEmpty
                                ? Text(
                                    'Enter an artist name and click search.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: custom_colors.pinkPrimary,
                                    ),
                                  )
                                : GestureDetector(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (artistInfo['images'] != null)
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 35,
                                                backgroundImage: NetworkImage(
                                                  artistInfo['images'][0],
                                                ),
                                              ),
                                              const SizedBox(width: 12.0),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${artistInfo['name']}',
                                                    style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: custom_colors
                                                          .pinkPrimary,
                                                    ),
                                                  ),
                                                  Text(
                                                    formatFollowers(artistInfo[
                                                        'followers']),
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                    onTap: () {
                                      if (selectedArtists.length >= 5) {
                                        showTopSnackBar(
                                          Overlay.of(context),
                                          const CustomSnackBar.error(
                                            message:
                                                "Higher than 5 singers cannot be added",
                                          ),
                                        );
                                      } else {
                                        String selectedArtistName =
                                            artistInfo['name'];
                                        if (selectedArtists
                                            .contains(selectedArtistName)) {
                                          showTopSnackBar(
                                            Overlay.of(context),
                                            const CustomSnackBar.error(
                                              message:
                                                  "The artist is already selected",
                                            ),
                                          );
                                        } else {
                                          selectedArtists
                                              .add(selectedArtistName);
                                          setState(() {
                                            singerList.insert(0, {
                                              'id': artistInfo['id'],
                                              'name': artistInfo['name'],
                                              'icon': artistInfo['images'][0],
                                              'followers':
                                                  artistInfo['followers'],
                                            });
                                          });

                                          showTopSnackBar(
                                            Overlay.of(context),
                                            const CustomSnackBar.success(
                                              message:
                                                  "The artist has chosen successfully",
                                            ),
                                          );
                                          print(selectedArtists);
                                        }
                                      }
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    setState(() {});
  }

  String formatFollowers(int followers) {
    String followersString = followers.toString();

    if (followersString.length >= 7) {
      int millionIndex = followersString.length - 6;
      return '${followersString.substring(0, millionIndex)}.${followersString.substring(millionIndex, millionIndex + 1)}M';
    } else if (followersString.length >= 4) {
      int thousandIndex = followersString.length - 3;
      return '${followersString.substring(0, thousandIndex)}.${followersString.substring(thousandIndex, thousandIndex + 1)}K';
    } else {
      return '$followers';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: custom_colors.pinkPrimary,
        title: const Text(
          "Recommend Artist",
          style: TextStyle(color: Colors.white),
        ),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 10),
                Text(
                  'Sana daha uygun önerim yapmam için sevdiğin şarkıcılardan birkaçını seç!',
                  style: TextStyle(
                    fontSize: 24,
                    color: custom_colors.pinkPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: singerList.length,
              itemBuilder: (context, index) {
                var singer = singerList[index];
                bool isSelected = selectedArtists.contains(singer['name']);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedArtists.remove(singer['name']);
                      } else {
                        if (selectedArtists.length >= 5) {
                          showTopSnackBar(
                            Overlay.of(context),
                            const CustomSnackBar.error(
                              message: "higher than 5 singer can not be added",
                            ),
                          );
                        } else {
                          selectedArtists.add(singer['name']);
                          print(selectedArtists);
                        }
                      }
                    });
                  },
                  child: Card(
                    color: isSelected ? Colors.green : null,
                    child: Column(
                      children: [
                        const SizedBox(height: 6),
                        CircleAvatar(
                          backgroundImage: NetworkImage(singer['icon']),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          singer['name'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Colors.white
                                : custom_colors.pinkPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                                fontSize: 12, color: Colors.black),
                            children: [
                              TextSpan(
                                text: formatFollowers(singer['followers']),
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : custom_colors.pinkPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: ' Followers',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 100),
            child: SizedBox(
              height: 50,
              width: 100,
              child: FloatingActionButton(
                heroTag: 'aaa',
                onPressed: () {
                  if (selectedArtists.length >= 5) {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.error(
                        message: "Higher than 5 singers cannot be added",
                      ),
                    );
                  } else {
                    showSelectedArtistDialog(selectedArtists.toString());
                    ;
                  }
                },
                backgroundColor: custom_colors.pinkPrimary,
                child: const Text(
                  'Şarkıcı Ara',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(28, 16, 8, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SizedBox(
                height: 50,
                child: FloatingActionButton(
                  heroTag: 'aaaads',
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  backgroundColor: custom_colors.pinkPrimary,
                  foregroundColor: Colors.white,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back),
                      SizedBox(width: 8),
                      Text('Geri'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 50,
                child: FloatingActionButton(
                  backgroundColor: custom_colors.pinkPrimary,
                  foregroundColor: Colors.white,
                  heroTag: 'aasdsaa',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TakePhoto(
                              selectedGenres: widget.selectedGenres,
                              selectedArtist: selectedArtists)),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('İleri'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
