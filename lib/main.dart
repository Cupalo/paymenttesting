import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:testingplugin/key.dart';
import 'package:testingplugin/paypal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // set the publishable key for Stripe - this is mandatory
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = '-';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          // primarySwatch: Colors.blue,
          ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final cardFormController = CardFormEditController();
  final cardController = CardEditController();
  Map<String, dynamic>? paymentIntentData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          // CardField(
          //   onCardChanged: (card) {
          //     print(card);
          //   },
          // ),
          // CardFormField(
          //   controller: cardController,
          //   onCardChanged: (card) {
          //     print(card);
          //   },
          //   // style: CardFormStyle(),
          // ),
          TextButton(
            onPressed: () async {},
            child: const Text('Stripe Function'),
          ),
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    children: [
                      CardField(
                        controller: CardEditController(),
                        onCardChanged: (details) {},
                        decoration: const InputDecoration(),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Stripe custom'),
          ),
          TextButton(
            onPressed: () async {
              // await Stripe.instance.presentPaymentSheet();
              // await Stripe.instance.initPaymentSheet(
              //     paymentSheetParameters: SetupPaymentSheetParameters());
              // create payment method
              // final paymentMethod = await Stripe.instance.createPaymentMethod(
              //   params: PaymentMethodParams.card(
              //     paymentMethodData: PaymentMethodData(),
              //   ),
              // );

              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text('Stripe'),
                      const SizedBox(height: 20),
                      // SizedBox(
                      //   child: CardField(
                      //     decoration: InputDecoration(
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      CardFormField(
                        controller: cardFormController,
                        onFocus: (focusedField) {},
                        onCardChanged: (details) {},
                        style: CardFormStyle(
                          placeholderColor: Colors.white,
                          textColor: Colors.white,
                          cursorColor: Colors.white,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text('Stripe'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => UsePaypal(
                    sandboxMode: true,
                    clientId: paypalClientId,
                    secretKey: paypalSecret,
                    returnURL: 'nativexo://paypalpay',
                    // returnURL: "https://samplesite.com/return",
                    cancelURL: "https://samplesite.com/cancel",
                    transactions: const [
                      {
                        "amount": {
                          "total": '10.12',
                          "currency": "USD",
                          "details": {
                            "subtotal": '10.12',
                            "shipping": '0',
                            "shipping_discount": 0
                          }
                        },
                        "description": "The payment transaction description.",
                        // "payment_options": {
                        //   "allowed_payment_method":
                        //       "INSTANT_FUNDING_SOURCE"
                        // },
                        "item_list": {
                          "items": [
                            {
                              "name": "A demo product",
                              "quantity": 1,
                              "price": '10.12',
                              "currency": "USD"
                            }
                          ],

                          // shipping address is not required though
                          // "shipping_address": {
                          //   "recipient_name": "Jane Foster",
                          //   "line1": "Travis County",
                          //   "line2": "",
                          //   "city": "Austin",
                          //   "country_code": "US",
                          //   "postal_code": "73301",
                          //   "phone": "+00000000",
                          //   "state": "Texas"
                          // },
                        }
                      }
                    ],
                    note: "Contact us for any questions on your order.",
                    onSuccess: (Map params) async {
                      print("onSuccess: $params");
                    },
                    onError: (error) {
                      print("onError: $error");
                    },
                    onCancel: (params) {
                      print('cancelled: $params');
                    },
                  ),
                ),
              );
            },
            child: const Text('Paypal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => UsePaypal(
                    sandboxMode: true,
                    clientId: paypalClientId2,
                    secretKey: paypalSecret2,
                    returnURL: 'nativexo://paypalpay',
                    // returnURL: "https://samplesite.com/return",
                    cancelURL: "https://samplesite.com/cancel",
                    transactions: const [
                      {
                        "amount": {
                          "total": '10.12',
                          "currency": "USD",
                          "details": {
                            "subtotal": '10.12',
                            "shipping": '0',
                            "shipping_discount": 0
                          }
                        },
                        "description": "The payment transaction description.",
                        // "payment_options": {
                        //   "allowed_payment_method":
                        //       "INSTANT_FUNDING_SOURCE"
                        // },
                        "item_list": {
                          "items": [
                            {
                              "name": "A demo product",
                              "quantity": 1,
                              "price": '10.12',
                              "currency": "USD"
                            }
                          ],

                          // shipping address is not required though
                          // "shipping_address": {
                          //   "recipient_name": "Jane Foster",
                          //   "line1": "Travis County",
                          //   "line2": "",
                          //   "city": "Austin",
                          //   "country_code": "US",
                          //   "postal_code": "73301",
                          //   "phone": "+00000000",
                          //   "state": "Texas"
                          // },
                        }
                      }
                    ],
                    note: "Contact us for any questions on your order.",
                    onSuccess: (Map params) async {
                      print("onSuccess: $params");
                    },
                    onError: (error) {
                      print("onError: $error");
                    },
                    onCancel: (params) {
                      print('cancelled: $params');
                    },
                  ),
                ),
              );
            },
            child: const Text('Paypal 2'),
          ),
          TextButton(
            // color: Colors.red,
            onPressed: payWithPaypal,
            child: const Text(
              'Pay with Paypal',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () {
              openPaymentSheetWidget(colorFull);
            },
            child: const Text('Stripe customColor'),
          ),
          TextButton(
            onPressed: () {
              openPaymentSheetWidget(colorDarkTheme);
            },
            child: const Text('Stripe darkTheme'),
          ),
        ],
      ),
    );
  }

  Future<void> openPaymentSheetWidget(
    PaymentSheetAppearanceColors appearanceColors,
  ) async {
    try {
      paymentIntentData = await callPaymentIntentApi('200', 'INR');
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          appearance: PaymentSheetAppearance(
            colors: appearanceColors,
            // shapes: PaymentSheetShape(borderRadius: 12),
            primaryButton: const PaymentSheetPrimaryButtonAppearance(
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Colors.blue,
                ),
              ),
            ),
            // colors: PaymentSheetAppearanceColors(background: blueShade50),
          ),
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Merchant Display Name',
        ),
      )
          .then((value) {
        showPaymentSheetWidget();
      });
    } catch (exe, s) {
      debugPrint('Exception:$exe$s');
    }
  }

  callPaymentIntentApi(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculatedAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      debugPrint("Body : $body");
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer $stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
      );
      return jsonDecode(response.body);
    } catch (err) {
      debugPrint('callPaymentIntentApi Exception: ${err.toString()}');
    }
  }

  Future<void> showPaymentSheetWidget() async {
    try {
      await Stripe.instance.presentPaymentSheet(
          // ignore: deprecated_member_use
          // parameters: PresentPaymentSheetParameters(
          //   clientSecret: paymentIntentData!['client_secret'],
          //   confirmPayment: true,
          // ),
          );
      setState(() {
        paymentIntentData = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blue,
          content: Text(
            "Payment Successfully Completed ",
            style: TextStyle(color: Colors.white),
          )));
    } on StripeException catch (e) {
      debugPrint('StripeException:  $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Get Stripe Exception"),
              ));
    } catch (e) {
      debugPrint('$e');
    }
  }

  calculatedAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }

  var colorDarkTheme = PaymentSheetAppearanceColors(
    background: Colors.grey.shade900,
    componentBackground: Colors.grey.shade900,
    componentDivider: Colors.grey,
    componentBorder: Colors.grey,
    primary: Colors.red,
    primaryText: Colors.white,
    componentText: Colors.white,
    secondaryText: Colors.white,
    placeholderText: Colors.grey,
    icon: Colors.red,
  );

  var colorFull = PaymentSheetAppearanceColors(
    background: Colors.grey.shade900,
    componentBackground: Colors.grey.shade900,
    componentDivider: Colors.white,
    componentBorder: Colors.red,
    primary: Colors.red,
    primaryText: Colors.blue,
    componentText: Colors.yellow,
    secondaryText: Colors.green,
    placeholderText: Colors.purple,
    icon: Colors.orange,
  );

  payWithPaypal() {
    // make PayPal payment
    print('test');

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => Payment(
          onFinish: (number) async {
            // payment done
            final snackBar = SnackBar(
              content: const Text("Payment done Successfully"),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Close',
                onPressed: () {
                  // Some code to undo the change.
                },
              ),
            );
            // _scaffoldKey.currentState
            //     .showSnackBar(snackBar);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            print('order id: $number');
            print('ddasdas');
          },
        ),
      ),
    );
  }
}
