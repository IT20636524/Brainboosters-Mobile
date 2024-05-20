import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../components/custom_text_field.dart';
import '../tools/form_validators.dart';

class RegistrationPage extends StatefulWidget {
  final FirebaseAnalytics analytics;

  const RegistrationPage({Key? key, required this.analytics}) : super(key: key);

  static String routeName = "/registration";

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _fullNameTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _confirmPasswordTextController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    checkForSignedInUser();
  }

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
        shadowColor: Colors.transparent,
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
                      "assets/images/reg_page_header_img.png",
                      fit: BoxFit.contain,
                      height: 200,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Create an Account! It’s Free!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Column(
                        children: [
                          EBuddyTextField(
                              controller: _fullNameTextController,
                              label: "Full Name",
                              hintText: "Enter your full name (ex. John Doe)",
                              password: false,
                              textInputType: TextInputType.name),
                          const SizedBox(height: 15),
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
                          const SizedBox(height: 15),
                          EBuddyTextField(
                              controller: _confirmPasswordTextController,
                              label: "Confirm Password",
                              hintText: "Confirm your password",
                              password: true,
                              textInputType: TextInputType.visiblePassword),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        String fullName = _fullNameTextController.text;
                        String email = _emailTextController.text;
                        String password = _passwordTextController.text;
                        String confirmPassword =
                            _confirmPasswordTextController.text;

                        if (FormValidators().isFullNameValid(fullName)) {
                          if (FormValidators().isEmail(email)) {
                            if (FormValidators().isPasswordValid(password)) {
                              if (FormValidators().isConfirmPasswordValid(
                                  password, confirmPassword)) {
                                try {
                                  final credential = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                                  if (credential.user != null) {
                                    await credential.user!
                                        .updateDisplayName(fullName);
                                    await credential.user!
                                        .sendEmailVerification();
                                    await credential.user!.reload();
                                    FirebaseAuth.instance.signOut();
                                    await widget.analytics
                                        .logSignUp(signUpMethod: "email");
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Account Created!"),
                                          content: const Text(
                                              "Please check your email to verify your account. You will not be able to log in until you verify your account. If you do not see the email, please check your spam folder. Redirecting to login page."),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.popAndPushNamed(
                                                    context, "/login");
                                              },
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title:
                                              const Text("An Error Occurred"),
                                          content: const Text(
                                              "An error occurred while creating your account. Please try again."),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'weak-password') {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Weak Password"),
                                          content: const Text(
                                              "The password provided is too weak. Please try again with a stronger password."),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else if (e.code == 'email-already-in-use') {
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              "Email Already In Use"),
                                          content: const Text(
                                              "The account already exists for that email. Please try again with a different email."),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                Navigator.popAndPushNamed(
                                                    context, "/login");
                                              },
                                              child: const Text("Go to Login"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                } catch (e) {
                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("An Error Occurred"),
                                        content: const Text(
                                            "An error occurred while creating your account. Please try again."),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("OK"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Passwords do not match. Please try again."),
                                  ),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      "Password must be at least 8 characters long. Please try again."),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Please enter a valid email. Please try again."),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Please enter a valid full name. Please try again."),
                            ),
                          );
                        }
                      },
                      child: const Text("Sign Up"),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.popAndPushNamed(context, "/login");
                          },
                          child: const Text("Sign In"),
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

  void checkForSignedInUser() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        if (user.emailVerified) {
          Navigator.popAndPushNamed(context, "/home");
        }
      }
    });
  }
}
