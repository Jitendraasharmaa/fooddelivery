import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fooddelivery/constants/app_colors.dart';
import 'package:fooddelivery/constants/app_constants.dart';
import 'package:fooddelivery/services/database.dart';
import 'package:fooddelivery/services/shared_pref_helper.dart';
import 'package:fooddelivery/widgets/button_widget.dart';
import 'package:http/http.dart' as http;

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  String? wallet, id;
  int? add;
  String errMessage = "";
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _enterAmountController = TextEditingController();
  Map<String, dynamic>? paymentIntent;

  @override
  void dispose() {
    _amountController.dispose();
    _enterAmountController.dispose();
    super.dispose();
  }

  getSharedPref() async {
    wallet = await SharedPrefHelper().getUserWallet();
    id = await SharedPrefHelper().getUserId();
    setState(() {});
  }

  onTheLoad() async {
    await getSharedPref();
    setState(() {});
  }

  @override
  void initState() {
    onTheLoad();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.only(top: 60),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
              child: Container(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Center(
                  child: Text(
                    "Wallet",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(color: Color(0xFFF2F2F2)),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/wallet.png",
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    width: 40.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your Wallet",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        wallet.toString(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontSize: 18,
                            ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Add money",
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      makePayment(100.toString());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE9E2E2)),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "Rs. 100",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      makePayment(500.toString());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE9E2E2)),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        " Rs. 500",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  GestureDetector(
                    onTap: () {
                      makePayment(1000.toString());
                    },
                    child: Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE9E2E2)),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          "Rs. 1000",
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      makePayment(2000.toString());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFE9E2E2)),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        "Rs 2000",
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.maxFinite,
              child: ButtonWidget(
                title: "Add Money",
                onTap: openEdit,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'INR');
      //Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
                paymentIntentClientSecret: paymentIntent!['client_secret'],
                style: ThemeMode.dark,
                merchantDisplayName: 'Jitendra'),
          )
          .then((value) {});

      displayPaymentSheet(amount);
    } catch (e, s) {
      print('exception:$e$s');
    }
  }

  displayPaymentSheet(String amount) async {
    add = int.parse(wallet!) + int.parse(amount);
    await SharedPrefHelper().saveUserWallet(add.toString());
    await DatabaseMethod().updateUserWallet(id!, add.toString());
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        add = int.parse(wallet!) + int.parse(amount);
        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.greenColor,
                          ),
                          Text("Payment Successfully"),
                        ],
                      ),
                    ],
                  ),
                ));
        //to update instant
        await getSharedPref();
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print('Error is:--->$error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${AppConstant().appSecretKey}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // ignore: avoid_print
      print('Payment Intent Body->>> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      // ignore: avoid_print
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final calculateAmount = (int.parse(amount) * 100);
    return calculateAmount.toString();
  }

  Future openEdit() async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.cancel)),
                  const SizedBox(
                    width: 60.0,
                  ),
                  const Center(
                    child: Text(
                      "Add Money",
                      style: TextStyle(
                        color: Color(0xFF008080),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              const Text("Amount"),
              const SizedBox(
                height: 10.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black38, width: 2.0),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _enterAmountController,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'Enter Amount'),
                ),
              ),
              Text(
                errMessage,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.errorColor,
                    ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    if (_enterAmountController.text.isNotEmpty) {
                      Navigator.pop(context);
                      makePayment(
                        _enterAmountController.text,
                      );
                      _enterAmountController.clear();
                    } else {
                      setState(
                        () {
                          errMessage = "Amount is not available";
                        },
                      );
                    }
                  },
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF008080),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Pay",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
