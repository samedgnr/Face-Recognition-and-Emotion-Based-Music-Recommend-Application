import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:music_recommendation_with_emotional_analysiss/models/colors.dart'
    as custom_colors;
import 'package:music_recommendation_with_emotional_analysiss/pages/recomendation%20pages/recommendation_result.dart';
import 'package:music_recommendation_with_emotional_analysiss/services/music_recommendation_service.dart';
import 'package:music_recommendation_with_emotional_analysiss/snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class TakePhoto extends StatefulWidget {
  final List<String> selectedGenres;
  final List<String> selectedArtist;
  const TakePhoto(
      {super.key, required this.selectedGenres, required this.selectedArtist});

  @override
  State<TakePhoto> createState() => _TakePhotoState();
}

class _TakePhotoState extends State<TakePhoto> {
  late Uint8List imageBytes;
  String emotion = '';
  bool isImageSelected = false;

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
    if (imageBytes.isNotEmpty) {
      try {
        Map<String, dynamic> result =
            await EmotionDetectionService.processImage(imageBytes);
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

  void getRecommendations(List<String> artist, List<String> genre) async {
    try {
      List<String> artists = artist;
      List<String> genres = genre;

      await processImage();

      Map<String, dynamic> result =
          await EmotionDetectionService.getRecommendations(
        emotion,
        genres,
        artists,
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: custom_colors.pinkPrimary,
        title: const Text(
          "photo",
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
              'Son olarak fotoğrafını çekelim! ',
              style: TextStyle(
                fontSize: 24,
                color: custom_colors.pinkPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 70),
            Center(
              child: SizedBox(
                height: 200,
                width: 200,
                child: FloatingActionButton(
                  heroTag: 'adsaa',
                  onPressed: () async {
                    await getImage();
                  },
                  backgroundColor: custom_colors.pinkPrimary,
                  child: const Icon(
                    Icons.camera_alt,
                    size: 100,
                    color: Colors.white,
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
                  backgroundColor: isImageSelected ? Colors.green : Colors.red,
                  foregroundColor: Colors.white,
                  heroTag: 'aasdsaa',
                  onPressed: isImageSelected
                      ? () {
                          getRecommendations(
                              widget.selectedArtist, widget.selectedGenres);
                        }
                      : () {
                        showTopSnackBar(
                          Overlay.of(context),
                          const CustomSnackBar.error(
                              message: "Do not forget to take a photo!"),
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
}
