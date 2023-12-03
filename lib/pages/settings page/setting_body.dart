import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/settings%20page/settings_listview.dart';

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
        backgroundColor: const Color.fromARGB(255, 34, 41, 50),
        title: const Text('Settings'),
      ),
      body: const SettingsListView(),
    );
  }
}
