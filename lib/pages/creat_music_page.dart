
import 'package:flutter/material.dart';
import '../models/colors.dart' as custom_colors;

class CreateMusic extends StatefulWidget {
  const CreateMusic({super.key});

  @override
  State<CreateMusic> createState() => _CreateMusicState();
}

class _CreateMusicState extends State<CreateMusic> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: const Text(
            "Create Music with Ai",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: custom_colors.pinkPrimary,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Text("Yakındaa..."),
    );
  }
}