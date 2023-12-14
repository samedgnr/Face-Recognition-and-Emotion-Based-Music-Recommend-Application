import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;


class SendPhoto extends StatefulWidget {
  const SendPhoto({super.key});

  @override
  State<SendPhoto> createState() => _SendPhotoState();
}

class _SendPhotoState extends State<SendPhoto> {
   String playlistUrl = '';
  Future<void> analyzeImage(BuildContext context) async {
    final url = Uri.parse(
        'https://berwyndentalconnection.com/wp-content/uploads/2018/04/Change-Your-Life-With-a-Smile.jpg');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Resmi geçici bir dosyaya kaydedin
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/temp_image.jpg');
        await tempFile.writeAsBytes(response.bodyBytes);

        // Dosyayı okuyun ve base64 kodlayın
        List<int> imageBytes = await tempFile.readAsBytes();
        String base64Image = base64Encode(imageBytes);

        // Resmi Python tarafına gönderin
        sendImageToPythonBackend(context, base64Image);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to fetch the image.')));
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('An error occurred.')));
    }
  }

// class PhotoAnalyzerScreen extends StatelessWidget {
  Future<void> sendImageToPythonBackend(
      BuildContext context, String base64Image) async {
    final response = await http.post(
      Uri.parse(
          'http://10.0.2.2:5000/analyze'), // Python backend URL'sini buraya ekleyin
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'image': base64Image,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        playlistUrl = data['playlist_url'];
      });
      // String emotion = data['emotion'];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Emotion: $playlistUrl')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to analyze the image.')));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Photo Analyzer'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () => analyzeImage(context),
            child: const Text('Analyze Image from File'),
            // Buton metnini güncelledik
          ),
        ));
  }
}
