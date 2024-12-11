import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/admin/admin_home_screen.dart';
import 'package:fooddelivery/constants/app_colors.dart';
import 'package:fooddelivery/widgets/button_widget.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> adminLogin() async {
    setState(() {
      isLoading = true;
      setState(() {});
    });
    final isValidForm = _formKey.currentState!.validate();
    if (isValidForm) {
      String username = _usernameController.text;
      String password = _passwordController.text;

      await FirebaseFirestore.instance.collection("admin").get().then(
        (snapshot) {
          snapshot.docs.forEach((result) {
            if (result.data()["id"] != username.trim()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.errorColor,
                  content: Text("Your ID invalid"),
                ),
              );
            } else if (result.data()["password"] != password.trim()) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: AppColors.errorColor,
                  content: Text("Password is invalid"),
                ),
              );
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AdminHomeScreen(),
                ),
              );
            }
          });
        },
      );
    }
    setState(() {
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 100),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            Center(
              child: Text(
                "Let's Start With Admin",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Username is required";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Password is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.maxFinite,
                            child: ButtonWidget(
                              title: "Login",
                              onTap: adminLogin,
                            ),
                          ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
