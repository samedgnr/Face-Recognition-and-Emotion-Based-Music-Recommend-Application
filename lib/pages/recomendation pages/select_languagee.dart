import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/models/colors.dart'
    as custom_colors;
import 'package:music_recommendation_with_emotional_analysiss/pages/recomendation%20pages/select_genres.dart';
import 'package:music_recommendation_with_emotional_analysiss/snack_bar.dart';

class SelectLanguagee extends StatefulWidget {
const SelectLanguagee({Key? key}) : super(key: key);

  @override
  State<SelectLanguagee> createState() => _SelectLanguageeState();
}

class _SelectLanguageeState extends State<SelectLanguagee> {
  Map<String, String> availableLanguage = {
    'English': 'EN',
    'Spanish': 'ES',
    'Chinese': 'ZH',
    'Hindi': 'HI',
    'Arabic': 'AR',
    'Portuguese': 'PT',
    'Bengali': 'BN',
    'Russian': 'RU',
    'Japanese': 'JA',
    'Punjabi': 'PA',
    'German': 'DE',
    'Javanese': 'JV',
    'Telugu': 'TE',
    'Marathi': 'MR',
    'Turkish': 'TR',
    'Tamil': 'TA',
    'Urdu': 'UR',
    'Gujarati': 'GU',
    'Malayalam': 'ML',
    'Kannada': 'KN',
    'Oriya': 'OR',
    'Sunda': 'SU',
    'Bhojpuri': 'BH',
    'Hausa': 'HA',
    'Tagalog': 'TL',
    'Yoruba': 'YO',
    'Maithili': 'MAI',
    'Ukrainian': 'UK',
  };

  Map<String, String> selectedLanguage = {'Turkish': 'TR', 'English': 'EN'};

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
              itemCount: availableLanguage.length,
              itemBuilder: (context, index) {
                String language = availableLanguage.keys.elementAt(index);
                return ListTile(
                  title: Text(language),
                  onTap: () {
                    setState(() {
                      if (selectedLanguage.length >= 5) {
                        mySnackBar(context, "5 den fazla dil eklenemez");
                        return;
                      } else {}
                      String languageCode = availableLanguage[language]!;
                      selectedLanguage[language] = languageCode;
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
              'Haydi senin duygu durumuna göre şarkı bulalım!',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: custom_colors.pinkPrimary),
            ),
            const SizedBox(height: 10),
            Text(
              'Hangi dilde şarkı dinlemek istersin? ',
              style: TextStyle(fontSize: 19, color: custom_colors.pinkPrimary),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: selectedLanguage.length,
                itemBuilder: (context, index) {
                  String language = selectedLanguage.keys.elementAt(index);
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
                                selectedLanguage.remove(language);
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
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 180),
              child: SizedBox(
                height: 50,
                width: 100,
                child: FloatingActionButton(
                  heroTag: 'aaa',
                  onPressed: _showLanguageDialog,
                  backgroundColor: custom_colors.pinkPrimary,
                  child: const Text(
                    'Dil Ekle',
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
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 50,
                child: FloatingActionButton(
                  heroTag: 'aa',
                  onPressed: () {
                    print(selectedLanguage.values.toList());
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  SelectGenres(selectedLanguages: selectedLanguage.values.toList())),
                    );
                  },
                  backgroundColor: custom_colors.pinkPrimary,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'İleri',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white)
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
