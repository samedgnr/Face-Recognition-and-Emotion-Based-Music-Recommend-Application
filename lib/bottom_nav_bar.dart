import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/home_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/my_playlists_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/search_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/settings%20page/setting_body.dart';

class NavBar extends StatefulWidget {
  int finalindex;

  NavBar({super.key, required this.finalindex});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  final widgetOptions = [
    HomePage(),
    const SearchPage(),
    const MyPlaylistsPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: widget.finalindex,
        onTap: (x) {
          setState(() {
            widget.finalindex = x;
          });
        },
        iconSize: 30,
        elevation: 8.0,
        showSelectedLabels: true,
        unselectedItemColor: Colors.white,
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.deepPurple,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Colors.deepPurple,
              ),
              label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.library_books,
                color: Colors.deepPurple,
              ),
              label: "Your Library"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.settings,
                color: Colors.deepPurple,
              ),
              label: "Settings"),
        ],
      ),
      body: widgetOptions[widget.finalindex],
    );
  }
}
