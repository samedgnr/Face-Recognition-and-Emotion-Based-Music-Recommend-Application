import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/playlist_page.dart';

class PlaylistSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> playlist;

  PlaylistSearchDelegate(this.playlist);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Map<String, dynamic>> filteredPlaylists = playlist
        .where((playlist) => playlist['playlistName']
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();
    return _buildPlaylistList(filteredPlaylists);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Map<String, dynamic>> suggestions = playlist
        .where((playlist) => playlist['playlistName']
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    return _buildPlaylistList(suggestions);
  }

  Widget _buildPlaylistList(List<Map<String, dynamic>> filteredPlaylists) {
    return filteredPlaylists.isEmpty
        ? const Center(
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
  }
}
