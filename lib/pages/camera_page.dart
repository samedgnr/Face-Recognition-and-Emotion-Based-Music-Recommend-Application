import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  String playlistUrl = '';
  final picker = ImagePicker();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Kamera'),
      ),
      body: Center(
        child: _image == null
            ? const Text('Resim seçilmedi.')
            : Image.file(_image!),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          takePictureAndAnalyze(context);
        },
        tooltip: 'Resim Çek',
        child: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Future<void> takePictureAndAnalyze(BuildContext context) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      String base64Image = base64Encode(await pickedFile.readAsBytes());
      sendImageToPythonBackend(context, base64Image);
      _image = File(pickedFile.path);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No image selected.')));
    }
  }

  Future<void> sendImageToPythonBackend(
      BuildContext context, String base64Image) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/analyze'),
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Emotion: $playlistUrl')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to analyze the image.')));
    }
  }
}
