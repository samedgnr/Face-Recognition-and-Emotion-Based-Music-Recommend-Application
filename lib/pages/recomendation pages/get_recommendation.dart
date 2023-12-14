import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/recomendation%20pages/camera_page.dart';

class GetRecommendations extends StatefulWidget {
  const GetRecommendations({super.key});

  @override
  State<GetRecommendations> createState() => _GetRecommendationsState();
}

class _GetRecommendationsState extends State<GetRecommendations> {
  List<String> selectedArtist = [""];
  List<String> selectedLanguage = [
    'TR',
    'EN',
  ];
  List<String> availableLanguage = [
    'AD',
    'AE',
    'AG',
    'AL',
    'AM',
    'AO',
    'AR',
    'AT',
    'AU',
    'AZ',
    'BA',
    'BB',
    'BD',
    'BE',
    'BF',
    'BG',
    'BH',
    'BI',
    'BJ',
    'BN',
    'BO',
    'BR',
    'BS',
    'BT',
    'BW',
    'BY',
    'BZ',
    'CA',
    'CD',
    'CG',
    'CH',
    'CI',
    'CL',
    'CM',
    'CO',
    'CR',
    'CV',
    'CW',
    'CY',
    'CZ',
    'DE',
    'DJ',
    'DK',
    'DM',
    'DO',
    'DZ',
    'EC',
    'EE',
    'EG',
    'ES',
    'ET',
    'FI',
    'FJ',
    'FM',
    'FR',
    'GA',
    'GB',
    'GD',
    'GE',
    'GH',
    'GM',
    'GN',
    'GQ',
    'GR',
    'GT',
    'GW',
    'GY',
    'HK',
    'HN',
    'HR',
    'HT',
    'HU',
    'ID',
    'IE',
    'IL',
    'IN',
    'IQ',
    'IS',
    'IT',
    'JM',
    'JO',
    'JP',
    'KE',
    'KG',
    'KH',
    'KI',
    'KM',
    'KN',
    'KR',
    'KW',
    'KZ',
    'LA',
    'LB',
    'LC',
    'LI',
    'LK',
    'LR',
    'LS',
    'LT',
    'LU',
    'LV',
    'LY',
    'MA',
    'MC',
    'MD',
    'ME',
    'MG',
    'MH',
    'MK',
    'ML',
    'MN',
    'MO',
    'MR',
    'MT',
    'MU',
    'MV',
    'MW',
    'MX',
    'MY',
    'MZ',
    'NA',
    'NE',
    'NG',
    'NI',
    'NL',
    'NO',
    'NP',
    'NR',
    'NZ',
    'OM',
    'PA',
    'PE',
    'PG',
    'PH',
    'PK',
    'PL',
    'PS',
    'PT',
    'PW',
    'PY',
    'QA',
    'RO',
    'RS',
    'RW',
    'SA',
    'SB',
    'SC',
    'SE',
    'SG',
    'SI',
    'SK',
    'SL',
    'SM',
    'SN',
    'SR',
    'ST',
    'SV',
    'SZ',
    'TD',
    'TG',
    'TH',
    'TJ',
    'TL',
    'TN',
    'TO',
    'TR',
    'TT',
    'TV',
    'TW',
    'TZ',
    'UA',
    'UG',
    'US',
    'UY',
    'UZ',
    'VC',
    'VE',
    'VN',
    'VU',
    'WS',
    'XK',
    'ZA',
    'ZM',
    'ZW'
  ];
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
  List<String> selectedGenres = ['Pop', 'Rock', 'Hip-Hop', 'Jazz', 'Classical'];
  List<String> selectedArtists = [
    'Ludwig van Beethoven',
    'Wolfgang Amadeus Mozart',
  ];
  Map<String, List<String>> topArtists = {
    'Pop': [
      'Ed Sheeran',
      'Beyoncé',
      'Ariana Grande',
      'Justin Bieber',
      'Dua Lipa',
      'Taylor Swift',
      'Shawn Mendes',
      'Lady Gaga',
      'The Weeknd',
      'Katy Perry'
    ],
    'Rock': [
      'Queen',
      'The Beatles',
      'Led Zeppelin',
      'AC/DC',
      'Pink Floyd',
      'Rolling Stones',
      'Nirvana',
      'U2',
      'Coldplay',
      'Linkin Park'
    ],
    'Hip-Hop': [
      'Drake',
      'Kendrick Lamar',
      'Eminem',
      'Cardi B',
      'Travis Scott',
      'Jay-Z',
      'Nicki Minaj',
      'Post Malone',
      'Kanye West',
      'Lil Wayne'
    ],
    'Jazz': [
      'Miles Davis',
      'John Coltrane',
      'Ella Fitzgerald',
      'Louis Armstrong',
      'Duke Ellington',
      'Charlie Parker',
      'Billie Holiday',
      'Thelonious Monk',
      'Chet Baker',
      'Stan Getz'
    ],
    'Classical': [
      'Ludwig van Beethoven',
      'Wolfgang Amadeus Mozart',
      'Johann Sebastian Bach',
      'Pyotr Ilyich Tchaikovsky',
      'Claude Debussy',
      'Antonio Vivaldi',
      'Franz Schubert',
      'Richard Wagner',
      'Giuseppe Verdi',
      'Frederic Chopin'
    ],
  };

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emotion Detection App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Hadi şarkı önerimi yapalım!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            const Text(
              'Dinleyemeyi sevdiğin dili seç:',
              style: TextStyle(fontSize: 18),
            ),
            Wrap(
              spacing: 8.0,
              children: selectedLanguage
                  .map((language) => Chip(
                        label: Text(language),
                        onDeleted: () {
                          setState(() {
                            selectedLanguage.remove(language);
                          });
                        },
                      ))
                  .toList(),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showAddLanguageDialog(context);
                  },
                  child: const Text('Dil Ekle'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Dinleyemeyi sevdiğin türü seç (5):',
              style: TextStyle(fontSize: 18),
            ),
            Wrap(
              spacing: 8.0,
              children: selectedGenres
                  .map((genre) => Chip(
                        label: Text(genre),
                        onDeleted: () {
                          setState(() {
                            selectedGenres.remove(genre);
                            selectedArtists
                                .clear(); // Clear selected artists when a genre is removed
                          });
                        },
                      ))
                  .toList(),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showAddGenreDialog(context);
                  },
                  child: const Text('Tür Ekle'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Şarkıcı seç:',
              style: TextStyle(fontSize: 18),
            ),
            // Display selected artists below "Şarkıcı seç" text
            if (selectedArtists.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Seçilen Şarkıcılar:'),
                  Wrap(
                    spacing: 8.0,
                    children: selectedArtists
                        .map((artist) => Chip(
                              label: Text(artist),
                              onDeleted: () {
                                setState(() {
                                  selectedArtists.remove(artist);
                                });
                              },
                            ))
                        .toList(),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CameraPage(
                      artists: selectedArtists,
                      genres: selectedGenres,
                    ),
                  ),
                );
              },
              child: const Text('Fotoğraf Çek'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGenreDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yeni Tür Ekle'),
          content: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Tür Ara',
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: availableGenres
                        .where((genre) => genre
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()))
                        .map((genre) => ListTile(
                              title: Text(genre),
                              onTap: () {
                                if (genre.isNotEmpty &&
                                    selectedGenres.length < 5 &&
                                    !selectedGenres.contains(genre)) {
                                  setState(() {
                                    selectedGenres.add(genre);
                                    selectedArtists = topArtists[genre] ?? [];
                                  });
                                }
                                Navigator.of(context).pop();
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showAddLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Yeni Dil Ekle'),
          content: Column(
            children: [
              TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: 'Dil Ara',
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: availableLanguage
                        .where((language) => language
                            .toLowerCase()
                            .contains(searchController.text.toLowerCase()))
                        .map((language) => ListTile(
                              title: Text(language),
                              onTap: () {
                                if (language.isNotEmpty &&
                                    !selectedLanguage.contains(language)) {
                                  setState(() {
                                    selectedLanguage.add(language);
                                  });
                                }
                                Navigator.of(context).pop();
                              },
                            ))
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
