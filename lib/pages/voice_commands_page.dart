
import 'package:flutter/material.dart';
import '../models/colors.dart' as custom_colors;

class VoiceCommands extends StatefulWidget {
  const VoiceCommands ({super.key});

  @override
  State<VoiceCommands> createState() => _VoiceCommandsState();
}

class _VoiceCommandsState extends State<VoiceCommands> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
          title: const Text(
            "Voice Commands",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: custom_colors.pinkPrimary,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: const Text("Yakındaa..."),
    );
  }
}