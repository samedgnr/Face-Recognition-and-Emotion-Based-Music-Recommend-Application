import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/recomendation%20pages/recommendation_result.dart';

import 'package:music_recommendation_with_emotional_analysiss/services/music_recommendation_service.dart';

class CameraPage extends StatefulWidget {
  final List<String> artists;
  final List<String> genres;

  const CameraPage({Key? key, required this.artists, required this.genres})
      : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late Uint8List imageBytes;
  String emotion = '';

  Future<void> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageBytes = await pickedFile.readAsBytes();
      print(imageBytes);
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
void getRecommendations() async {
  try {
    List<String> artists = widget.artists;
    List<String> genres = widget.genres;

    // Wait for processImage to complete before moving on
    await processImage();

    Map<String, dynamic> result = await EmotionDetectionService.getRecommendations(
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
        title: const Text('Flutter Kamera'),
      ),
      body: const Center(
        child: Text("fotoğraf çek"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await getImage();
          
    
          getRecommendations();
        },
        
        tooltip: 'Resim Çek',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }
}

