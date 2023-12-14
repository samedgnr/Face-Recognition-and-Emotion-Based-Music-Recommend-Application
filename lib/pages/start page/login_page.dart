import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:music_recommendation_with_emotional_analysiss/snack_bar.dart';
import '../../helper/helper_function.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback showRegisterPage;

  const LoginPage({super.key, required this.showRegisterPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final bool _isLoading = false;
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
              mySnackBar(context, value);
            }
          });
        } catch (e) {
          mySnackBar(context, "Invalid login or password.\nPlease try again.");
        }
      } else {
        mySnackBar(context, "Password length must be longer than 8");
      }
    } else {
      mySnackBar(context, "Please enter a valid email");
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
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(238, 238, 238, 0)),
      child: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //email textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                        child: TextField(
                          cursorColor: Colors.deepPurple,
                          controller: _emailController,
                          decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple),
                              ),
                              labelText: 'E-mail',
                              labelStyle: TextStyle(color: Colors.deepPurple)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    //password textfield
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                        child: TextField(
                          cursorColor: Colors.deepPurple,
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepPurple),
                              ),
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.deepPurple)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    //sign in button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: GestureDetector(
                        onTap: signIn,
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.deepPurple,
                              borderRadius: BorderRadius.circular(12)),
                          child: const Center(
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Spotify Icon button
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Center the icons horizontally
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                            onTap: () {
                              signWithGoogle();
                            },
                            child: const Icon(
                              FontAwesomeIcons
                                  .google, // Use the Spotify icon from FontAwesome
                              size: 40,
                              color: Colors
                                  .green, // You can change the color as needed
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                            onTap: () {
                              // Handle YouTube login action here
                              // Implement the functionality as needed
                            },
                            child: const Icon(
                              FontAwesomeIcons
                                  .youtube, // Use the YouTube icon from FontAwesome
                              size: 40,
                              color: Colors
                                  .red, // You can change the color as needed
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: GestureDetector(
                            onTap: () {
                              // Handle YouTube login action here
                              // Implement the functionality as needed
                            },
                            child: const Icon(
                              FontAwesomeIcons
                                  .apple, // Use the YouTube icon from FontAwesome
                              size: 40,
                              color: Colors
                                  .white, // You can change the color as needed
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    //not a member? register now
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Not a member?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepPurple),
                        ),
                        GestureDetector(
                          onTap: widget.showRegisterPage,
                          child: const Text(
                            '   Register now',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
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
