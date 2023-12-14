import 'package:flutter/material.dart';

class RecommendationResult extends StatefulWidget {
  final List<dynamic> recommendedSongs;
  const RecommendationResult({super.key, required this.recommendedSongs});

  @override
  State<RecommendationResult> createState() => _RecommendationResultState();
}

class _RecommendationResultState extends State<RecommendationResult> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended Songs'),
      ),
      body: ListView.builder(
        itemCount: widget.recommendedSongs.length,
        itemBuilder: (context, index) {
          var track = widget.recommendedSongs[index];

          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(track[2] ?? ''),
              subtitle: Text(
                track[3],
                // track['artists']
                //     .map<String>((artist) => artist[3])
                //     .join(', '),
              ),
              trailing: Image.network(track[1]),
              onTap: () {
                // Handle tap on the song (e.g., open details screen)
                // You can navigate to a details screen or perform any other action here
              },
            ),
          );
        },
      ),
    );
  }
}
