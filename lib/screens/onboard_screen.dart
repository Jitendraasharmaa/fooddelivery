import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/app_colors.dart';
import 'package:fooddelivery/screens/login_screen.dart';
import 'package:fooddelivery/screens/signup_screen.dart';

import '../widgets/onboarding_content.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  int currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 50),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Image.asset(
                        contents[index].image.toString(),
                        width: MediaQuery.of(context).size.width,
                        height: 450,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(height: 40),
                      Text(
                        contents[index].title.toString(),
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        contents[index].description.toString(),
                        style:
                            Theme.of(context).textTheme.bodyMedium!.copyWith(),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(
              contents.length,
              (index) {
                return Container(
                  height: 10,
                  width: currentIndex == index ? 18 : 10,
                  margin: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: currentIndex == index
                        ? AppColors.errorColor
                        : AppColors.secondaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.maxFinite,
            margin: const EdgeInsets.only(bottom: 50, top: 20),
            child: ElevatedButton(
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );
                }
                _pageController.nextPage(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.bounceIn);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorColor,
                  padding: const EdgeInsets.symmetric(vertical: 20)),
              child: Text(
                currentIndex == contents.length - 1 ? "Start" : "Next",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 20,
                      color: AppColors.whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
