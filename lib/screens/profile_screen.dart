import 'package:flutter/material.dart';
import 'package:fooddelivery/services/auth_methods.dart';
import 'package:fooddelivery/services/shared_pref_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? profile, name, email;

  getSharedPre() async {
    profile = await SharedPrefHelper().getUserprofile();
    name = await SharedPrefHelper().getUserName();
    email = await SharedPrefHelper().getUserEmail();
    setState(() {});
  }

  onTheLoadSharedPref() async {
    await getSharedPre();
    setState(() {});
  }

  @override
  void initState() {
    onTheLoadSharedPref();
    super.initState();
  }

  // Future<void> _logout(BuildContext context) async {
  //   try {
  //     await FirebaseAuth.instance.signOut();
  //     // Navigate to the login screen
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //       builder: (context) => const LoginScreen(),
  //     ));
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error logging out: $e')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: <Widget>[
            Center(
              child: ClipOval(
                child: Image.asset(
                  "assets/images/boy.jpg",
                  width: 250,
                  height: 250,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.person_2_outlined,
                  size: 25,
                ),
                title: Text(
                  "Name",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                subtitle: Text(
                  name.toString(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 18,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.email,
                  size: 25,
                ),
                title: Text(
                  "Email",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                subtitle: Text(
                  email.toString(),
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 18,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.email,
                  size: 25,
                ),
                title: Text(
                  "Terms & Conditions",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                AuthMethods().delete();
              },
              child: Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.delete,
                    size: 25,
                  ),
                  title: Text(
                    "Delete Account",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: GestureDetector(
                onTap: () {
                  AuthMethods().signOut();
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.login_outlined,
                    size: 25,
                  ),
                  title: Text(
                    "Logout",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
