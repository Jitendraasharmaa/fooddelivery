import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/app_colors.dart';
import 'package:fooddelivery/screens/signup_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController _restEmailController = TextEditingController();

  @override
  void dispose() {
    _restEmailController.dispose();
    super.dispose();
  }

  resetPassword() async {
    setState(() {
      isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      final email = _restEmailController.text;
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: AppColors.greenColor,
              content: Text(
                "Password Reset Email has been sent !",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        }
        _restEmailController.clear();
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = "No user found for that email.";
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Forgot Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextFormField(
                controller: _restEmailController,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a valid email address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator(
                      strokeWidth: 1,
                      backgroundColor: AppColors.errorColor,
                    )
                  : SizedBox(
                      width: double.maxFinite,
                      child: ElevatedButton(
                        onPressed: resetPassword,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          backgroundColor: AppColors.mainColor,
                        ),
                        child: Text(
                          'Reset Password',
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 18,
                                    color: AppColors.whiteColor,
                                  ),
                        ),
                      ),
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Have not you already account?",
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text("Sign up"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
