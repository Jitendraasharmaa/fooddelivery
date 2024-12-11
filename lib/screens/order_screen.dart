import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/app_colors.dart';
import 'package:fooddelivery/services/database.dart';
import 'package:fooddelivery/services/shared_pref_helper.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? id, wallet;
  Stream? foodItemsStream;
  double totalPrice = 0, amount2 = 0.0;

  void startTimer() {
    Timer(const Duration(seconds: 1), () {
      amount2 = totalPrice;
      setState(() {});
    });
  }

  getSharePref() async {
    id = await SharedPrefHelper().getUserId();
    print("==============$id=====================");
    wallet = await SharedPrefHelper().getUserWallet();
    print("==============$wallet=====================");
    setState(() {});
  }

  onTheSharePref() async {
    await getSharePref();
    foodItemsStream = await DatabaseMethod().getFoodCartItem(id!);
    setState(() {});
  }

  @override
  void initState() {
    onTheSharePref();
    startTimer();
    super.initState();
  }

  Widget fetchCartItems() {
    return StreamBuilder(
      stream: foodItemsStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  totalPrice = totalPrice + ds['Price'];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text(
                          ds['Quantity'].toString(),
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                        ),
                        const SizedBox(width: 10),
                        Image.asset(
                          "assets/images/food.jpg",
                          width: 100,
                          height: 100,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              ds['Title'],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25,
                                  ),
                            ),
                            SizedBox(
                              width: 200,
                              child: Text(
                                ds['Price'].toString(),
                                overflow: TextOverflow.clip,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
              )
            : const Center(
                child: Text("No Item added"),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 16,
        title: Text(
          "Orders",
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: fetchCartItems(),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: AppColors.greenColor.withOpacity(0.5),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        "Rs $totalPrice",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    ],
                  ),
                  const SizedBox(width: 20), // Use SizedBox instead of Spacer
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      backgroundColor: AppColors.greenColor,
                    ),
                    onPressed: () async {
                      double amount = await double.parse(wallet!) - amount2;
                      await DatabaseMethod().updateUserWallet(id!, amount.toString());
                      await SharedPrefHelper()
                          .saveUserWallet(wallet.toString());
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   const SnackBar(
                      //     backgroundColor: AppColors.greenColor,
                      //     content: Text(
                      //       "Place an order",
                      //       style: TextStyle(fontSize: 20.0),
                      //     ),
                      //   ),
                      // );
                    },
                    child: Text(
                      "Check Out",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.whiteColor,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
