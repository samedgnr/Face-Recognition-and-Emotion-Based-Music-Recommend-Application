import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/home_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/library_page.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/search_page.dart';
import '../models/colors.dart' as custom_colors;

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
        selectedItemColor: custom_colors.pinkPrimary,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: custom_colors.buttonColor,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: custom_colors.buttonColor,
              ),
              label: "Search"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.library_books,
                color: custom_colors.buttonColor,
              ),
              label: "Your Library"),
          
        ],
      ),
      body: widgetOptions[widget.finalindex],
    );
  }
}
