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
}
