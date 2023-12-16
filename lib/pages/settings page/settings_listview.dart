import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/pages/settings%20page/settings_list.dart';
import '../../helper/helper_function.dart';
import '../../services/auth_service.dart';

class SettingsListView extends StatefulWidget {
  const SettingsListView({super.key});

  @override
  State<SettingsListView> createState() => _SettingsListViewState();
}

class _SettingsListViewState extends State<SettingsListView> {
  final user = FirebaseAuth.instance.currentUser!;
  String userName = "";
  String email = "";
  String number = "";
  AuthService authService = AuthService();

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      setState(() {
        userName = val!;
      });
    });
    await HelperFunctions.getUserNumberFromSF().then((val) {
      setState(() {
        number = val!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: SizedBox(
              height: 180,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("lib/images/noPhoto.jpg"),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        userName,
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          onTap: () {},
        ),
        const Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: SizedBox(
            height: 330,
            child: SettingsList(),
          ),
        ),
      ],
    );
  }
}
