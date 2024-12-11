import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/app_colors.dart';
import 'package:fooddelivery/services/database.dart';
import 'package:fooddelivery/services/shared_pref_helper.dart';

class SingleProductScreen extends StatefulWidget {
  final String title;
  final String description;
  final double price;

  const SingleProductScreen(
      {super.key,
      required this.title,
      required this.description,
      required this.price});

  @override
  State<SingleProductScreen> createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  int qty = 1;
  double totalPrice = 0.0;
  String? id;

  getSharePre() async {
    id = await SharedPrefHelper().getUserId();
    print("==============$id=========================");
    setState(() {});
  }

  onLoadSharePre() async {
    await getSharePre();
    setState(() {});
  }

  @override
  void initState() {
    onLoadSharePre();
    totalPrice = widget.price;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "assets/images/salad2.png",
                width: 300,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (qty > 1) {
                        qty--;
                        // totalPrice = totalPrice - widget.price;
                        totalPrice = widget.price * qty;
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Icon(
                      Icons.remove,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                Text(
                  qty.toString(),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 10.0),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      qty++;
                      // totalPrice = totalPrice + widget.price;
                      totalPrice = widget.price * qty;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: AppColors.mainColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Icon(
                      Icons.add,
                      color: AppColors.whiteColor,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Text(
              widget.description,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Delivery On Time",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(width: 20),
                const Icon(
                  Icons.schedule,
                  color: AppColors.greenColor,
                ),
                const SizedBox(width: 10),
                const Text("30 mins")
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: AppColors.greenColor.withOpacity(0.5),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
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
                        "Rs. ${totalPrice.toString()}",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                      )
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0.0, backgroundColor: AppColors.greenColor),
                    onPressed: () async {
                      Map<String, dynamic> cartItems = {
                        "Title": widget.title,
                        "Description": widget.description,
                        "Price": totalPrice,
                        "Quantity": qty
                      };
                      await DatabaseMethod().addToCart(cartItems, id!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        (const SnackBar(
                          backgroundColor: AppColors.greenColor,
                          content: Text(
                            "product added to cart successfully",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        )),
                      );
                    },
                    child: Text(
                      "Add to cart",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.whiteColor,
                          ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
