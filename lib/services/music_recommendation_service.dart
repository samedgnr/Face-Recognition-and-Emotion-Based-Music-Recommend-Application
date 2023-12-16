// emotion_detection_service.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class EmotionDetectionService {
  static const String baseUrl =
      "http://10.0.2.2:5000"; // Update with your Flask server IP

  static Future<Map<String, dynamic>> processImage(Uint8List imageBytes) async {
    String base64Image = base64Encode(imageBytes);
    final response = await http.post(
      Uri.parse('$baseUrl/process_image'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': base64Image}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to process image');
    }
  }

  static Future<Map<String, dynamic>> getRecommendations(
      String emotion, List<String> genre, List<String> artist) async {
    List<String> artists = artist;
    List<String> genres = genre;
    print(genres);
    print(artists);
    final response = await http.post(
      Uri.parse('$baseUrl/get_recommendations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'emotion': emotion,
        'artist_names': artists,
        'genres': genres,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get recommendations');
    }
  }
}
