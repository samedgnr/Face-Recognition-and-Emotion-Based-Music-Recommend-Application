import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../helper/helper_function.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:animate_do/animate_do.dart';
import '../../models/colors.dart' as custom_colors;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;

  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  AuthService authService = AuthService();

  Future signIn() async {
    if (RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_emailController.text)) {
      if (_passwordController.text.length >= 8) {
        try {
          await authService
              .signInWithEmailandPassword(
                  _emailController.text, _passwordController.text)
              .then((value) async {
            if (value == true) {
              QuerySnapshot snapshot = await DatabaseService(
                      uid: FirebaseAuth.instance.currentUser!.uid)
                  .gettingUserData(_emailController.text);
              //saving the values to do shared preferences
              await HelperFunctions.saveUserLoggedInStatus(true);
              await HelperFunctions.saveUserEmailSF(_emailController.text);
              await HelperFunctions.saveUserNameSF(
                  snapshot.docs[0]['fullName']);
              await HelperFunctions.saveUserNumberSF(
                  snapshot.docs[0]['number']);
            } else {
              showTopSnackBar(
                Overlay.of(context),
                CustomSnackBar.error(
                    backgroundColor:
                        custom_colors.blackSecondary.withOpacity(1),
                    message: value),
              );
            }
          });
        } catch (e) {
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              backgroundColor: custom_colors.blackSecondary.withOpacity(1),
              message: "Invalid e-mail or password.\nPlease try again.",
            ),
          );
        }
      } else {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "Password length must be longer than 8.",
            backgroundColor: custom_colors.blackSecondary.withOpacity(1),
          ),
        );
      }
    } else {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: "Please enter a valid e-mail.",
          backgroundColor: custom_colors.blackSecondary.withOpacity(1),
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          custom_colors.pinkPrimary.withOpacity(1),
          custom_colors.pinkPrimary.withOpacity(.9),
          custom_colors.pinkPrimary.withOpacity(.6)
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1300),
                      child: const Text(
                        "Welcome Back!",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(50),
                    child: Column(
                      children: <Widget>[
                        const SizedBox(
                          height: 10,
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1400),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: custom_colors.pinkPrimary
                                            .withOpacity(.3),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10))
                                  ]),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
                                    child: TextField(
                                      controller: _emailController,
                                      decoration: const InputDecoration(
                                          hintText: "E-mail",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade200))),
                                    child: TextField(
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                          hintText: "Password",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1500),
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(color: Colors.grey),
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1600),
                            child: MaterialButton(
                              onPressed: () {
                                signIn();
                              },
                              height: 50,
                              // margin: EdgeInsets.symmetric(horizontal: 50),
                              color: custom_colors.buttonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Center(
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        const SizedBox(
                          height: 30,
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1700),
                            child: const Text(
                              "Or\nContinue with...",
                              style: TextStyle(color: Colors.grey),
                              textAlign: TextAlign.center,
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: FadeInUp(
                                  duration: const Duration(milliseconds: 1800),
                                  child: MaterialButton(
                                    onPressed: () {},
                                    child: Center(
                                      child: Image.asset(
                                        'lib/images/apple.png',
                                        height: 40,
                                      ),
                                    ),
                                  )),
                            ),
                            const SizedBox(
                              width: 0,
                            ),
                            Expanded(
                              child: FadeInUp(
                                  duration: const Duration(milliseconds: 1900),
                                  child: MaterialButton(
                                    onPressed: () {
                                      signWithGoogle();
                                    },
                                    child: Center(
                                      child: Image.asset(
                                        'lib/images/google.png',
                                        height: 40,
                                      ),
                                    ),
                                  )),
                            ),
                            Expanded(
                              child: FadeInUp(
                                  duration: const Duration(milliseconds: 1900),
                                  child: MaterialButton(
                                    onPressed: () {
                                      signWithGoogle();
                                    },
                                    child: Center(
                                      child: Image.asset(
                                        'lib/images/Spotify.png',
                                        height: 40,
                                      ),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1700),
                            child: GestureDetector(
                                onTap: widget.showRegisterPage,
                                child:  Text.rich(
                                  TextSpan(
                                    text: "Don't have an account?  ",
                                    style: const TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: "Let's create!",
                                        style: TextStyle(color: custom_colors.buttonColor,fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ))),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  signWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
