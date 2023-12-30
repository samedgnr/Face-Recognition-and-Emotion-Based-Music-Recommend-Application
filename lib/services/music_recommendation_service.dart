// emotion_detection_service.dart

import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class EmotionDetectionService {
  static const String baseUrl =
      "http://10.0.2.2:5000";

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
      String emotion, List<String> genre, List<String> artist,String language) async {
    List<String> artists = artist;
    List<String> genres = genre;
    String genree = "${language.toLowerCase()} ${genre[0].toLowerCase()}"  ;
    print(genres);
    print(artists);
    print(language);
    final response = await http.post(
      Uri.parse('$baseUrl/get_recommendations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'emotion': emotion,
        'artist_names': artists,
        'genres': genree.split(","),
        
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get recommendations');
    }
  }

   static Future<List<Map<String, dynamic>>> getTopArtists(language,genre) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/get_top_artists'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'market': language,
          'genre': genre,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['result']);
      } else {
        throw Exception('Failed to get top artists');
      }
    } catch (e) {
      throw Exception('Failed to get top artists: $e');
    }
  }
  



  static Future<Map<String, dynamic>> getArtistInfo(String artistName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/get_artist_info'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'artist_name': artistName,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get artist info');
      }
    } catch (e) {
      print('Exception during getArtistInfo: $e');
      throw Exception('Failed to get artist info');
    }
  }
}
