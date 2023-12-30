import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_recommendation_with_emotional_analysiss/models/colors.dart'
    as custom_colors;
import 'package:music_recommendation_with_emotional_analysiss/pages/recomendation%20pages/recommendation_result.dart';
import 'package:music_recommendation_with_emotional_analysiss/services/music_recommendation_service.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TakePhoto extends StatefulWidget {
  final List<String> selectedGenres;
  final List<String> selectedArtist;
  final String selectedLanguage;
  const TakePhoto(
      {super.key,
      required this.selectedGenres,
      required this.selectedArtist,
      required this.selectedLanguage});

  @override
  State<TakePhoto> createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  late Uint8List? imageBytes;
  String emotion = '';
  bool isImageSelected = false;
  bool isProcessingRecommendations = false;

  List<String> emotionList = [
    'Happy',
    'Sad',
    'Angry',
    'Neutral',
    'Surprised',
    'Disgusted',
    'Fearful',
  ];

  @override
  void initState() {
    super.initState();
    imageBytes = null;
  }

  Future<void> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        isImageSelected = true;
      });
      imageBytes = await pickedFile.readAsBytes();
    } else {
      print('No image selected');
    }
  }

  Future<void> processImage() async {
    if (imageBytes != null && imageBytes!.isNotEmpty) {
      try {
        Map<String, dynamic> result =
            await EmotionDetectionService.processImage(imageBytes!);
        setState(() {
          emotion = result['emotion'];
        });
      } catch (e) {
        print('Error processing image: $e');
      }
    } else {
      print('No image selected');
    }
  }

  void getRecommendations(
      List<String> artist, List<String> genre, String language) async {
    try {
      setState(() {
        isProcessingRecommendations = true;
      });

      await processImage();

      Map<String, dynamic> result =
          await EmotionDetectionService.getRecommendations(
        emotion,
        genre,
        artist,
        language,
      );

      if (result.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecommendationResult(
              recommendedSongs: result['recommendations'],
              emotion: emotion,
            ),
          ),
        );
      } else {
        print('No recommendations found in the result');
      }
    } catch (e) {
      print('Error getting recommendations: $e');
    } finally {
      setState(() {
        isProcessingRecommendations = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: custom_colors.pinkPrimary,
        title: const Text(
          "Emotion Detection",
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
      body: FutureBuilder(
          future: Future.delayed(
              Duration(seconds: 0)), 
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                isProcessingRecommendations) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Analyzing recommendations...'),
                  ],
                ),
              );
            } else {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 10),
                      Text(
                        'Son olarak fotoğrafını çekelim! ',
                        style: TextStyle(
                          fontSize: 24,
                          color: custom_colors.pinkPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: FloatingActionButton(
                            heroTag: 'adsaa',
                            onPressed: () async {
                              await getImage();
                            },
                            backgroundColor: custom_colors.pinkPrimary,
                            child: const Icon(
                              Icons.camera_alt,
                              size: 70,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Fotoğraf çekmek istemiyorsan aşağıdan istediğin duygu durumunu da seçebilirsin!',
                        style: TextStyle(
                          fontSize: 24,
                          color: custom_colors.pinkPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 230,
                        child: Center(
                          child: ListView.builder(
                            itemCount: emotionList.length,
                            itemBuilder: (context, index) {
                              return buildEmotionButton(emotionList[index]);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
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
                  backgroundColor: emotion != "" || isImageSelected
                      ? Colors.green
                      : Colors.red,
                  foregroundColor: Colors.white,
                  heroTag: 'aasdsaa',
                  onPressed: emotion != "" || isImageSelected
                      ? () {
                          print(emotion);
                          getRecommendations(widget.selectedArtist,
                              widget.selectedGenres, widget.selectedLanguage);
                        }
                      : () {
                          print(emotion);
                          showTopSnackBar(
                            Overlay.of(context),
                            const CustomSnackBar.error(
                                message:
                                    "Do not forget to state your emotion!"),
                          );
                        },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sonucu Görelim!',
                        style: TextStyle(fontSize: 16),
                      ),
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

  Widget buildEmotionButton(String emotionn) {
    bool isSelected = emotion == emotionn;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: TextButton(
        onPressed: () {
          setState(() {
            if (isSelected) {
              isImageSelected = false;
              emotion = "";
            } else {
              emotion = emotionn;
              imageBytes = null;
            }
          });
        },
        style: TextButton.styleFrom(
          backgroundColor:
              isSelected ? Colors.green : custom_colors.pinkPrimary,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emotionn,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
