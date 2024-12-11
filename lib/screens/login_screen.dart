import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/app_colors.dart';
import 'package:fooddelivery/screens/forgot_password_screen.dart';
import 'package:fooddelivery/screens/signup_screen.dart';
import 'package:fooddelivery/widgets/button_widget.dart';
import 'package:random_string/random_string.dart';

import '../services/shared_pref_helper.dart';
import '../widgets/bottom_navigation_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isVisible = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  login() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()){
      try {
        final email = _emailController.text;
        final password = _passwordController.text;
        final auth = FirebaseAuth.instance;
        final user = await auth.signInWithEmailAndPassword(
            email: email, password: password);

        if (user.user != null) {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const BottomNav(),
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = "No user found for that email.";
        } else if (e.code == 'wrong-password') {
          message = "Incorrect password provided.";
        } else if (e.code == 'invalid-email') {
          message = "The email address is not valid.";
        } else {
          message = "An unexpected error occurred. Please try again.";
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: AppColors.errorColor,
              content: Text(
                message,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ), // Optional: Set a background color
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 100),
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.secondaryColor,
                ),
                child: Image.asset("assets/images/logo.png"),
              ),
              const SizedBox(height: 150),
              Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Sign in",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: "Enter Email",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Username';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: isVisible,
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                isVisible = !isVisible;
                                setState(() {});
                              },
                              child: isVisible
                                  ? const Icon(Icons.visibility_off)
                                  : const Icon(Icons.visibility),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen(),
                            ));
                          },
                          child: const Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "Forgot Password?",
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        isLoading
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: double.maxFinite,
                                child: ButtonWidget(
                                  title: "Login",
                                  onTap: login,
                                ),
                              ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Have not you account?'),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text('Sign up'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
