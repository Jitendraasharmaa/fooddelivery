import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddelivery/constants/app_colors.dart';
import 'package:fooddelivery/screens/single_product_screen.dart';
import 'package:fooddelivery/services/database.dart';
import 'package:fooddelivery/utils/styles/text_style.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool iceCream = false, pizza = false, salad = false, burger = false;

  Stream? foodItemStream;

  onTheFoodItemStream() async {
    foodItemStream = await DatabaseMethod().getFoodItem("Pizza");
    setState(() {});
  }

  @override
  void initState() {
    onTheFoodItemStream();
    super.initState();
  }
  Widget fetchingAllItems() {
    return StreamBuilder(
      stream: foodItemStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                // padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const SizedBox(
                  width: 10,
                ),
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>  SingleProductScreen(
                            title: ds['name'],
                            description: ds['description'],
                            price: ds['price'].toDouble(),
                          ),
                        ),
                      );
                    },
                    child: Material(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "assets/images/food.jpg",
                                width: 150,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ds['name'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 5.0),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    ds['description'],
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Text(
                                  ds['price'].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : const CircularProgressIndicator();
      },
    );
  }

  Widget verticalItems() {
    return StreamBuilder(
      stream: foodItemStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.separated(
                itemCount: snapshot.data.docs.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Image.asset(
                          "assets/images/salad3.png",
                          width: 150,
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ds['name'],
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            Text(
                              ds['description'],
                              overflow: TextOverflow.clip,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              ds['price'].toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color: AppColors.secondaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                  height: 10,
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50.0, 20, 0.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hello Rythm,",
                  style: AppStyles.textTextBoldStyle(),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(20)),
                  child: Badge(
                    label: Text(
                      "1",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteColor),
                    ),
                    backgroundColor: AppColors.redColor,
                    padding: const EdgeInsets.all(3.0),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Delicious Food",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  "Discover and Get Great Food",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () async {
                        iceCream = true;
                        pizza = false;
                        salad = false;
                        burger = false;
                        foodItemStream =
                            await DatabaseMethod().getFoodItem("Ice-cream");
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: iceCream
                                ? AppColors.blueLightColor
                                : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 1,
                                color: AppColors.blackColor.withOpacity(0.5),
                                offset: const Offset(0, 0),
                              ),
                            ]),
                        child: Image.asset(
                          "assets/images/ice-cream.png",
                          color: iceCream
                              ? AppColors.greenColor
                              : AppColors.blackColor,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        iceCream = false;
                        pizza = true;
                        salad = false;
                        burger = false;
                        foodItemStream =
                            await DatabaseMethod().getFoodItem("Pizza");
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: pizza
                                ? AppColors.blueLightColor
                                : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 1,
                                color: AppColors.blackColor.withOpacity(0.5),
                                offset: const Offset(0, 0),
                              ),
                            ]),
                        child: Image.asset(
                          "assets/images/pizza.png",
                          color: pizza
                              ? AppColors.greenColor
                              : AppColors.blackColor,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        iceCream = false;
                        pizza = false;
                        salad = true;
                        burger = false;
                        foodItemStream =
                            await DatabaseMethod().getFoodItem("Burger");
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: salad
                                ? AppColors.blueLightColor
                                : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 1,
                                color: AppColors.blackColor.withOpacity(0.5),
                                offset: const Offset(0, 0),
                              ),
                            ]),
                        child: Image.asset(
                          "assets/images/salad.png",
                          color: salad
                              ? AppColors.greenColor
                              : AppColors.blackColor,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        iceCream = false;
                        pizza = false;
                        salad = false;
                        burger = true;
                        foodItemStream =
                            await DatabaseMethod().getFoodItem("Salad");
                        setState(() {});
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            color: burger
                                ? AppColors.blueLightColor
                                : AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 1,
                                spreadRadius: 1,
                                color: AppColors.blackColor.withOpacity(0.5),
                                offset: const Offset(0, 0),
                              ),
                            ]),
                        child: Image.asset(
                          "assets/images/burger.png",
                          color: burger
                              ? AppColors.greenColor
                              : AppColors.blackColor,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.all(10),
                  height: 250,
                  child: fetchingAllItems(),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        child: verticalItems(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
