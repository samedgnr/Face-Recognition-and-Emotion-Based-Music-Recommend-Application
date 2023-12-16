import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  //referance for oru collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference playlistCollection =
      FirebaseFirestore.instance.collection("playlists");

  //saving user data
  Future savingUserData(
      String name, String number, String email, String password) async {
    createPlaylist(name, uid!, "Beğenilenler");
    return await userCollection.doc(uid).set({
      "fullName": name,
      "number": number,
      "email": email,
      "playlists": [],
      "password": password,
      "profilePic": "",
      "spotifyToken": "",
      "uid": uid,
    });
  }

  //getting user data
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  // get user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  // creating a group
  Future createPlaylist(String userName, String id, String playlistName) async {
    DocumentReference playlistDocumentReference = await playlistCollection.add({
      "playlistName": playlistName,
      "playlistIcon": "",
      "playlistOwner": "${id}_$userName",
      "playlistId": "",
      "playlistSongs": "",
      "playlistCreateTime": FieldValue.serverTimestamp(),
    });

    // update the playlist
    await playlistDocumentReference.update({
      "playlistId": playlistDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(id);
    return await userDocumentReference.update({
      "playlist": FieldValue.arrayUnion(
          ["${playlistDocumentReference.id}_$playlistName"])
    });
  }
  Future<String> createPlaylistGetId(String userName, String id, String playlistName) async {
  DocumentReference playlistDocumentReference = await playlistCollection.add({
    "playlistName": playlistName,
    "playlistIcon": "",
    "playlistOwner": "${id}_$userName",
    "playlistId": "",  
    "playlistSongs": "",
    "playlistCreateTime": FieldValue.serverTimestamp(),
  });

  await playlistDocumentReference.update({
    "playlistId": playlistDocumentReference.id,
  });

  DocumentReference userDocumentReference = userCollection.doc(id);
  await userDocumentReference.update({
    "playlist": FieldValue.arrayUnion(["${playlistDocumentReference.id}_$playlistName"]),
  });

  return playlistDocumentReference.id;
}

  // getting the songs
  getSongs(String playlistId) async {
    return playlistCollection.doc(playlistId).collection("songs").snapshots();
  }

  //getting the playlist owner
  Future getPlaylistOwner(String playlistId) async {
    DocumentReference d = playlistCollection.doc(playlistId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['playlistOwner'];
  }

  //getting the playlist name
  Future getPlaylistName(String playlistId) async {
    DocumentReference d = playlistCollection.doc(playlistId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['playlistName'];
  }

  //get playlist icon
  Future getPlaylistIcon(String playlistId) async {
    DocumentReference d = playlistCollection.doc(playlistId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['playlistIcon'];
  }

  Future getPlaylistCreateTime(String playlistId) async {
    DocumentReference d = playlistCollection.doc(playlistId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['playlistCreateTime'];
  }

  // get playlists
  getPlaylists(String userId) async {
    return playlistCollection
        .where('playlistOwner', isEqualTo: userId)
        //.orderBy('playlistCreateTime', descending: true)
        .snapshots();
  }

  Future updateSpotifyToken(String spotiftToken) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    await userDocumentReference.update({"spotifyToken": spotiftToken});
  }

//  create songs
  addSongs(String playlistId, Map<String, dynamic> songData) async {
    DocumentReference documentReference = await playlistCollection
        .doc(playlistId)
        .collection("songs")
        .add(songData);
    String documentId = documentReference.id;

    await documentReference.update({
      "songId": documentId,
      "SongAddTime": FieldValue.serverTimestamp(),
    });
  }

// delete playlist
  deletePlaylist(String playlistId) {
    playlistCollection.doc(playlistId).delete();
  }

// delete song playlist
  deleteSongPlaylist(String playlistId, String songId) {
    DocumentReference playlistRef =
        FirebaseFirestore.instance.collection('playlists').doc(playlistId);
    playlistRef.collection('songs').doc(songId).delete();
  }

  //like a song 
  Future<void> updateIsLiked(String playlistId, String songId, bool isLiked,
      String userId, Map<String, dynamic> songData) async {
    CollectionReference songsCollectionn = FirebaseFirestore.instance
        .collection('playlists')
        .doc(playlistId)
        .collection('songs');

    QuerySnapshot songsQuery = await songsCollectionn
        .where('SongTrackId', isEqualTo: songData["SongTrackId"])
        .get();

    for (QueryDocumentSnapshot songDoc in songsQuery.docs) {
      await songDoc.reference.update({
        "songisLiked": isLiked,
      });
    }
    if (isLiked) {
      CollectionReference playlistCollection =
          FirebaseFirestore.instance.collection('playlists');
      QuerySnapshot playlistQuery = await playlistCollection
          .where('playlistOwner', isEqualTo: userId)
          .where('playlistName', isEqualTo: "Beğenilenler")
          .get();
      DocumentSnapshot playlistDoc = playlistQuery.docs.first;

      CollectionReference songsCollection =
          playlistDoc.reference.collection('songs');

      DocumentReference addedSongDocRef = await songsCollection.add(songData);

      String songId = addedSongDocRef.id;

      await addedSongDocRef.update({
        "songId": songId,
      });
    } else {
      CollectionReference playlistCollection =
          FirebaseFirestore.instance.collection('playlists');
      QuerySnapshot playlistQuery = await playlistCollection
          .where('playlistOwner', isEqualTo: userId)
          .where('playlistName', isEqualTo: "Beğenilenler")
          .get();

      if (playlistQuery.size > 0) {
        DocumentSnapshot playlistDoc = playlistQuery.docs.first;

        QuerySnapshot songsQuery = await playlistDoc.reference
            .collection('songs')
            .where('SongTrackId', isEqualTo: songData["SongTrackId"])
            .get();

        if (songsQuery.size > 0) {
          songsQuery.docs.first.reference.delete();
        } else {
          print('Belirtilen trackId değerine sahip şarkı bulunamadı.');
        }
      } else {
        print('Beğenilenler playlisti bulunamadı.');
      }
    }
  }

  //get likedSongs
  Future<dynamic> getLikedSongs(String userId) async {
    CollectionReference playlistCollection =
        FirebaseFirestore.instance.collection('playlists');

    QuerySnapshot playlistQuery = await playlistCollection
        .where('playlistOwner', isEqualTo: userId)
        .where('playlistName', isEqualTo: "Beğenilenler")
        .get();

    DocumentSnapshot playlistDoc = playlistQuery.docs.first;

    return playlistDoc.reference.collection('songs').snapshots();
  }
}
