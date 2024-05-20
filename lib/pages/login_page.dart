import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/custom_text_field.dart';
import '../tools/form_validators.dart';

class LoginPage extends StatefulWidget {
  final FirebaseAnalytics analytics;

  LoginPage({Key? key, required this.analytics}) : super(key: key);

  static String routeName = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.passthrough,
        children: [
          Image.asset(
            "assets/backgrounds/startups_background.png",
            fit: BoxFit.cover,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/login_page_header_img.png",
                      fit: BoxFit.contain,
                      height: 200,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Welcome back! Login with your credentials.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Column(
                        children: [
                          EBuddyTextField(
                              controller: _emailTextController,
                              label: "Email",
                              hintText: "Enter your email",
                              password: false,
                              textInputType: TextInputType.emailAddress),
                          const SizedBox(height: 15),
                          EBuddyTextField(
                              controller: _passwordTextController,
                              label: "Password",
                              hintText: "Enter your password",
                              password: true,
                              textInputType: TextInputType.visiblePassword),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        String email = _emailTextController.text;
                        String password = _passwordTextController.text;

                        if (FormValidators().isEmail(email)) {
                          if (FormValidators().isPasswordValid(password)) {
                            try {
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email, password: password);

                              if (credential.user != null) {
                                if (credential.user!.emailVerified) {
                                  widget.analytics
                                      .logLogin(loginMethod: "email");
                                  Navigator.popAndPushNamed(context, '/home');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text(
                                          "Please verify your email before logging in."),
                                      action: SnackBarAction(
                                        label: "Resend",
                                        onPressed: () async {
                                          try {
                                            credential.user!
                                                .sendEmailVerification();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    "Verification email sent to ${credential.user!.email}."),
                                              ),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "An error occurred. Please try again later."),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                  FirebaseAuth.instance.signOut();
                                }
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("No user found for that email."),
                                  ),
                                );
                              } else if (e.code == 'wrong-password') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Wrong password provided for that user."),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "An error occurred. Please try again later."),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Password must be at least 8 characters long."),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter a valid email."),
                            ),
                          );
                        }
                      },
                      child: const Text("Sign In"),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don’t have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, "/registration");
                          },
                          child: const Text("Sign Up"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    widget.analytics.setCurrentScreen(screenName: "Login Page");
    FirebaseAuth.instance.authStateChanges().listen(
      (User? user) async {
        if (user != null) {
          if (user.emailVerified) {
            Navigator.popAndPushNamed(context, '/home');
          }
        }
      },
    );
  }
}
