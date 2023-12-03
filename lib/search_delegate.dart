import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/playlist_page.dart';

class PlaylistSearchDelegate extends SearchDelegate {
  final Stream<QuerySnapshot>? playlist;
  

  PlaylistSearchDelegate(this.playlist);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: playlist,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Veri alınamadı: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData || snapshot.data.docs.isEmpty) {
          return const Center(
            child: Text('Veri bulunamadı.'),
          );
        }

        // Filter playlist based on the search query
        List<DocumentSnapshot> filteredPlaylists = snapshot.data.docs
            .where((playlist) =>
                playlist['playlistName']
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();

        return filteredPlaylists.isEmpty
            ? Center(
                child: Text('No matching playlists found.'),
              )
            : ListView.builder(
                itemCount: filteredPlaylists.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaylistPage(
                            playlistId: filteredPlaylists[index]['playlistId'],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: SizedBox(
                          width: 80,
                          height: 100,
                          child: Center(
                            child: Text(
                              filteredPlaylists[index]['playlistName'],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions while typing the search query
    // You can implement this if needed
    return Container();
  }
}
