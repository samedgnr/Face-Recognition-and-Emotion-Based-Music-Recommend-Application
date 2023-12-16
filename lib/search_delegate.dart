import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/playlist_page.dart';
import '../models/colors.dart' as custom_colors;

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

  String getAfterUnderscore(String playlistOwner) {
    int indexOfUnderscore = playlistOwner.indexOf('_');
    if (indexOfUnderscore != -1 &&
        indexOfUnderscore < playlistOwner.length - 1) {
      return playlistOwner.substring(indexOfUnderscore + 1);
    } else {
      return playlistOwner;
    }
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
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: custom_colors.pinkPrimary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: const DecorationImage(
                            image: NetworkImage(
                              "https://community.spotify.com/t5/image/serverpage/image-id/25294i2836BD1C1A31BDF2/image-size/original?v=mpbl-1&px=-1",
                              //snapshot.data.docs[index]['playlistIcon'],
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, 
                          children: [
                            Text(
                              filteredPlaylists[index]['playlistName'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Playlist: ${getAfterUnderscore(filteredPlaylists[index]['playlistOwner'])}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
