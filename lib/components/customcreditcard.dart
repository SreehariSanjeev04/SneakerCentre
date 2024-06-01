import 'package:flutter/material.dart';
class CustomCreditCard extends StatefulWidget {
  final String cardNumber;
  final String expiry;

  const CustomCreditCard({Key? key, required this.cardNumber, required this.expiry}) : super(key: key);

  @override
  State<CustomCreditCard> createState() => _CustomCreditCardState();
}

class _CustomCreditCardState extends State<CustomCreditCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        height: 200,
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: const Alignment(1.0, -1.2),
              child: Image.asset(
                'assets/images/mastercard.png',
                width: 100,
                height: 80,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                widget.cardNumber,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 30, bottom: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    children: [
                      Text(
                        'CARD HOLDER',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                      Text(
                        'User',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'VALID THRU',
                        style: TextStyle(color: Colors.white, fontSize: 8),
                      ),
                      Text(
                        widget.expiry,
                        style: const TextStyle(color: Colors.white, fontSize: 18),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
