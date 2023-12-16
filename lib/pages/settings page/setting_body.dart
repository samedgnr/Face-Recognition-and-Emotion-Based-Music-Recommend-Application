import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/settings%20page/settings_listview.dart';
import '../../models/colors.dart' as custom_colors;

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: custom_colors.pinkPrimary,
        title: const Text(
          'Settings',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: const SettingsListView(),
    );
  }
}