import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Spotify Recommendations',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _emotionController = TextEditingController();
  TextEditingController _artistIdsController = TextEditingController();
  TextEditingController _genresController = TextEditingController();
  String _recommendationsResult = '';

  Future<void> _getRecommendations() async {
    final Map<String, dynamic> requestData = {
      'emotion': _emotionController.text,
      'artist_ids': _artistIdsController.text.split(','), // Split artist IDs by comma
      'genres': _genresController.text.split(','), // Split genres by comma
    };

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/get_recommendations'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(requestData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        _recommendationsResult = data['recommendations'].toString();
      });
    } else {
      throw Exception('Failed to load recommendations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Spotify Recommendations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emotionController,
              decoration: InputDecoration(labelText: 'Emotion'),
            ),
            TextField(
              controller: _artistIdsController,
              decoration: InputDecoration(labelText: 'Artist IDs (comma-separated)'),
            ),
            TextField(
              controller: _genresController,
              decoration: InputDecoration(labelText: 'Genres (comma-separated)'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getRecommendations,
              child: Text('Get Recommendations'),
            ),
            SizedBox(height: 16),
            Text('Recommendations: $_recommendationsResult'),
          ],
        ),
      ),
    );
  }
}