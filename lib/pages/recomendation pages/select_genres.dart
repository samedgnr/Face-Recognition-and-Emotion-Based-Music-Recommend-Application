import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/models/colors.dart'
    as custom_colors;
import 'package:music_recommendation_with_emotional_analysiss/pages/recomendation%20pages/select_singer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class SelectGenres extends StatefulWidget {
  final List<String> selectedLanguages;

  const SelectGenres({Key? key, required this.selectedLanguages})
      : super(key: key);

  @override
  State<SelectGenres> createState() => _SelectGenresState();
}

class _SelectGenresState extends State<SelectGenres> {
  List<String> availableGenres = [
    'acoustic',
    'afrobeat',
    'alt-rock',
    'alternative',
    'ambient',
    'anime',
    'black-metal',
    'bluegrass',
    'blues',
    'bossanova',
    'brazil',
    'breakbeat',
    'british',
    'cantopop',
    'chicago-house',
    'children',
    'chill',
    'classical',
    'club',
    'comedy',
    'country',
    'dance',
    'dancehall',
    'death-metal',
    'deep-house',
    'detroit-techno',
    'disco',
    'disney',
    'drum-and-bass',
    'dub',
    'dubstep',
    'edm',
    'electro',
    'electronic',
    'emo',
    'folk',
    'forro',
    'french',
    'funk',
    'garage',
    'german',
    'gospel',
    'goth',
    'grindcore',
    'groove',
    'grunge',
    'guitar',
    'happy',
    'hard-rock',
    'hardcore',
    'hardstyle',
    'heavy-metal',
    'hip-hop',
    'holidays',
    'honky-tonk',
    'house',
    'idm',
    'indian',
    'indie',
    'indie-pop',
    'industrial',
    'iranian',
    'j-dance',
    'j-idol',
    'j-pop',
    'j-rock',
    'jazz',
    'k-pop',
    'kids',
    'latin',
    'latino',
    'malay',
    'mandopop',
    'metal',
    'metal-misc',
    'metalcore',
    'minimal-techno',
    'movies',
    'mpb',
    'new-age',
    'new-release',
    'opera',
    'pagode',
    'party',
    'philippines-opm',
    'piano',
    'pop',
    'pop-film',
    'post-dubstep',
    'power-pop',
    'progressive-house',
    'psych-rock',
    'punk',
    'punk-rock',
    'r-n-b',
    'rainy-day',
    'reggae',
    'reggaeton',
    'road-trip',
    'rock',
    'rock-n-roll',
    'rockabilly',
    'romance',
    'sad',
    'salsa',
    'samba',
    'sertanejo',
    'show-tunes',
    'singer-songwriter',
    'ska',
    'sleep',
    'songwriter',
    'soul',
    'soundtracks',
    'spanish',
    'study',
    'summer',
    'swedish',
    'synth-pop',
    'tango',
    'techno',
    'trance',
    'trip-hop',
    'turkish',
    'work-out',
    'world-music'
  ];

  List<String> selectedGenres = ['Pop'];

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dil Seç'),
          content: Container(
            height: 300,
            width: 300,
            child: ListView.builder(
              itemCount: availableGenres.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(availableGenres[index]),
                  onTap: () {
                    setState(() {
                      if (selectedGenres.length >= 1) {
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.error(
                              message: "higher than 1 genres can not be added"),
                        );
                        return;
                      } else {
                        String genreCode = availableGenres[index];
                        selectedGenres.add(genreCode);
                      }
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
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
        title: const Text(
          "Recommend Song",
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            Text(
              'Hangi türde şarkı dinlemek istersin? ',
              style: TextStyle(
                fontSize: 24,
                color: custom_colors.pinkPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: selectedGenres.length,
                itemBuilder: (context, index) {
                  String language = selectedGenres.elementAt(index);
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(language),
                        Hero(
                          tag: UniqueKey(),
                          child: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                selectedGenres.remove(language);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 470),
              child: SizedBox(
                height: 50,
                width: 100,
                child: FloatingActionButton(
                  heroTag: 'aaa',
                  onPressed: _showLanguageDialog,
                  backgroundColor: custom_colors.pinkPrimary,
                  child: const Text(
                    'Tür Değiştir',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
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
                          builder: (context) => SelectSinger(
                              selectedLanguages: widget.selectedLanguages,
                              selectedGenres: selectedGenres)),
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
