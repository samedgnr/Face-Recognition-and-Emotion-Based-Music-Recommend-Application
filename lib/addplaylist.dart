import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/helper/helper_function.dart';
import 'package:music_recommendation_with_emotional_analysiss/services/auth_service.dart';
import 'package:music_recommendation_with_emotional_analysiss/services/database_service.dart';

class AddPlaylist extends StatefulWidget {
  const AddPlaylist({super.key});

  @override
  State<AddPlaylist> createState() => _AddPlaylistState();
}

class _AddPlaylistState extends State<AddPlaylist> {
  String userName = "";
  String number = "";
  String email = "";
  AuthService authService = AuthService();
  Stream? groups;

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  // string manipulation
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  void gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNumberFromSF().then((value) {
      setState(() {
        number = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      // FutureBuilder'ın future özelliğine createPlaylist fonksiyonunu ekleyin
      future: createPlaylist(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Asenkron işlem tamamlandığında buraya gelir
          return Text('Playlist oluşturuldu!');
        } else if (snapshot.hasError) {
          // Hata durumunda buraya gelir
          return Text('Hata oluştu: ${snapshot.error}');
        } else {
          // Asenkron işlem tamamlanana kadar beklenen durum
          return CircularProgressIndicator();
        }
      },
    );
  }

  createPlaylist() {
    String playlistName = "WORLD TOP 100";

    DatabaseService().createPlaylist(
        userName, FirebaseAuth.instance.currentUser!.uid, playlistName);
  }
}
