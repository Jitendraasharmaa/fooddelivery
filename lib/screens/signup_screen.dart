import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/app_colors.dart';
import 'package:fooddelivery/screens/login_screen.dart';
import 'package:fooddelivery/screens/onboard_screen.dart';
import 'package:fooddelivery/services/database.dart';
import 'package:fooddelivery/services/shared_pref_helper.dart';
import 'package:fooddelivery/widgets/bottom_navigation_bar.dart';
import 'package:random_string/random_string.dart';

final firebase = FirebaseAuth.instance;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  String userName = "", email = "", password = "";

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  register() async {
    setState(() {
      setState(() {
        isLoading = true;
      });
    });
    if (_formKey.currentState!.validate()) {
      setState(() {
        email = _emailController.text;
        password = _passwordController.text;
      });
      try {
        UserCredential userCredential =
            await firebase.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(userCredential);
        ScaffoldMessenger.of(context).showSnackBar(
          (const SnackBar(
            backgroundColor: AppColors.greenColor,
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0),
            ),
          )),
        );
        String id = randomAlpha(10);
        Map<String, dynamic> addUserInfo = {
          'name': _usernameController.text,
          'email': _emailController.text,
          'wallet': "0",
          "id": id,
        };
        //adding the data into firebase Fire store
        await DatabaseMethod().addUserDetails(addUserInfo, id);

        //Saving the user details to local storage
        await SharedPrefHelper().saveUserId(id);
        await SharedPrefHelper().saveUserName(_usernameController.text);
        await SharedPrefHelper().saveUserEmail(_emailController.text);
        await SharedPrefHelper().saveUserWallet("0");

        //clearing all the text field
        _usernameController.clear();
        _emailController.clear();
        _passwordController.clear();
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const BottomNav(),
            ),
          );
        }
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.errorColor,
                content: Text(
                  "Password Provided is too Weak",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            );
          }
        } else if (e.code == "email-already-in-use") {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: AppColors.errorColor,
                content: Text(
                  "Account Already exists",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            );
          }
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
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          hintText: "Enter username",
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
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: "Enter email",
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
                        decoration: const InputDecoration(
                          hintText: "Enter password",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Username';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 30),
                      isLoading
                          ? const CircularProgressIndicator()
                          : SizedBox(
                              width: double.maxFinite,
                              child: ElevatedButton(
                                onPressed: register,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.mainColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20)),
                                child: Text(
                                  "Sign up",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                        color: AppColors.whiteColor,
                                      ),
                                ),
                              ),
                            ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Have you already account?'),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text('Sign in'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
