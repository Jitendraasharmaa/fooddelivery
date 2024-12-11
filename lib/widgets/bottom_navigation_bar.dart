import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/app_colors.dart';
import 'package:fooddelivery/screens/home_screen.dart';
import 'package:fooddelivery/screens/order_screen.dart';
import 'package:fooddelivery/screens/profile_screen.dart';
import 'package:fooddelivery/screens/wallet.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;
  late List<Widget> pages;
  late HomeScreen homepage;
  late ProfileScreen profile;
  late WalletScreen wallet;
  late OrderScreen orderScreen;

  @override
  void initState() {
    homepage = const HomeScreen();
    profile = const ProfileScreen();
    wallet = const WalletScreen();
    orderScreen = const OrderScreen();
    pages = [homepage, orderScreen, wallet, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        // height: 65,
        backgroundColor: AppColors.whiteColor,
        color: AppColors.mainColor,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: const [
          Icon(Icons.home_outlined, color: AppColors.whiteColor),
          Icon(Icons.shopping_bag_outlined, color: AppColors.whiteColor),
          Icon(Icons.wallet_outlined, color: AppColors.whiteColor),
          Icon(Icons.person_outline, color: AppColors.whiteColor),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
