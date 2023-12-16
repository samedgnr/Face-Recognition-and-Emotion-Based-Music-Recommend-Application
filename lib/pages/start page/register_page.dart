import 'package:flutter/material.dart';
import '../../helper/helper_function.dart';
import '../../services/auth_service.dart';
import '../../models/colors.dart' as custom_colors;
import 'package:animate_do/animate_do.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({super.key, required this.showLoginPage});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  AuthService authService = AuthService();

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future signUp() async {
    if (_nameController.text.trim().isNotEmpty) {
      if (RegExp(r'^(?:[+0][1-9])?[0-9]{10,12}$')
          .hasMatch(_numberController.text)) {
        if (RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(_emailController.text)) {
          if (_passwordController.text.length >= 8) {
            if (_passwordController.text.trim() ==
                _confirmPasswordController.text.trim()) {
              await authService
                  .registerUserWithEmailandPassword(
                _nameController.text,
                _numberController.text,
                _emailController.text,
                _passwordController.text,
              )
                  .then((value) async {
                if (value == true) {
                  //saving the shared preference state
                  await HelperFunctions.saveUserLoggedInStatus(true);
                  await HelperFunctions.saveUserNameSF(_nameController.text);
                  await HelperFunctions.saveUserNumberSF(
                      _numberController.text);
                  await HelperFunctions.saveUserEmailSF(_emailController.text);
                } else {
                  showTopSnackBar(
                    Overlay.of(context),
                    CustomSnackBar.error(message: value),
                  );
                }
              });
            } else {
              showTopSnackBar(
                Overlay.of(context),
                const CustomSnackBar.error(
                  message: "Passwords don't match!",
                ),
              );
            }
          } else {
            showTopSnackBar(
              Overlay.of(context),
              const CustomSnackBar.error(
                  message: "Password length must be longer than 8"),
            );
          }
        } else {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(message: "Please enter a valid email"),
          );
        }
      } else {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.error(message: "Please enter a valid number"),
        );
      }
    } else {
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(message: "Please enter a valid name"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                          "Sign Up",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                        duration: const Duration(milliseconds: 1300),
                        child: const Text(
                          "Welcome to your emotions!",
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
                            height: 0,
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
                                                  color:
                                                      Colors.grey.shade200))),
                                      child: TextField(
                                        controller: _nameController,
                                        decoration: const InputDecoration(
                                            hintText: "Name",
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
                                                  color:
                                                      Colors.grey.shade200))),
                                      child: TextField(
                                        controller: _numberController,
                                        decoration: const InputDecoration(
                                            hintText: "Number",
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
                                                  color:
                                                      Colors.grey.shade200))),
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
                                                  color:
                                                      Colors.grey.shade200))),
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
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color:
                                                      Colors.grey.shade200))),
                                      child: TextField(
                                        controller: _confirmPasswordController,
                                        obscureText: true,
                                        decoration: const InputDecoration(
                                            hintText: "Confirm Password",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(
                            height: 40,
                          ),
                          FadeInUp(
                              duration: const Duration(milliseconds: 1600),
                              child: MaterialButton(
                                onPressed: () {
                                  signUp();
                                },
                                height: 50,
                                color: custom_colors.buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Center(
                                  child: Text(
                                    "SIGN UP",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                          const SizedBox(
                            height: 40,
                          ),
                          FadeInUp(
                              duration: const Duration(milliseconds: 1700),
                              child: GestureDetector(
                                onTap: widget.showLoginPage,
                                child: Text.rich(
                                  TextSpan(
                                    text: "Have an account?  ",
                                    style: const TextStyle(color: Colors.black),
                                    children: [
                                      TextSpan(
                                        text: " Let's sign in!",
                                        style: TextStyle(color: custom_colors.buttonColor,fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
