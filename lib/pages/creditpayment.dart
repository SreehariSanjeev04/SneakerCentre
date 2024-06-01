// ignore_for_file: unnecessary_const

import 'package:ecommerce/components/customcreditcard.dart';
import 'package:ecommerce/pages/authpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CreditPaymentPage extends StatefulWidget {
  final VoidCallback submitDelivery;
  const CreditPaymentPage({Key? key, required this.submitDelivery}) : super(key: key);

  @override
  State<CreditPaymentPage> createState() => _CreditPaymentPageState();
}

class _CreditPaymentPageState extends State<CreditPaymentPage> {
  final _cardController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final cardNumberValidation = RegExp(r"\b\d{4}\s\d{4}\s\d{4}\s\d{4}\b");
  final expValidation = RegExp(r"0[1-9]|1[0-2]\/\d{2}");
  final cvvValidation = RegExp(r"\d{3}");
  GlobalKey<FormState> formKey = GlobalKey();
  String cardNumber = 'XXXX XXXX XXXX XXXX';
  String expiryDate = 'MM/YY';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Credit Card',
          style: TextStyle(color: Colors.deepOrange, fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            
            children: [
              
              const SizedBox(height: 30),
              CustomCreditCard(
                expiry: expiryDate,
                cardNumber: cardNumber,
              ),
              const SizedBox(height: 30),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            cardNumber = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty || !cardNumberValidation.hasMatch(value) || value.length != 19) {
                            return 'Invalid format';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          hintText: 'Card Number',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.deepOrange),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty || !cvvValidation.hasMatch(value)) {
                            return "Invalid Format";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          hintText: 'CVV',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.deepOrange),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            expiryDate = value;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty || !expValidation.hasMatch(value)) {
                            return "Invalid Format";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(15),
                          hintText: 'Expiry Date (MM/YY)',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.deepOrange),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    widget.submitDelivery();
                    showDialog(context: (context), builder: (context) {
                        return AlertDialog(
                          title: const Text('Purchase Confirmed!'),
                          content: const Text('You have successfully completed the purchase!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                                  return const AuthPage();
                                }), (route) => true);
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        );
                      });
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
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

