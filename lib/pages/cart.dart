import 'package:ecommerce/pages/address.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final String promoCode;
  const Cart({Key? key, required this.cart, this.promoCode=''}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final promoController = TextEditingController();
  bool usedPromo = false;
  double discountedPrice = 0;
  void deleteFromCart(int index) {
    setState(() {
      discountedPrice -= widget.cart[index]['price'] * 0.5;
      totalPrice -= widget.cart[index]['price'];
      widget.cart.removeAt(index);
    });
  }

  double totalPrice = 0;

  @override
  void initState() {
    for (int i = 0; i < widget.cart.length; i++) {
      setState(() {
        totalPrice += widget.cart[i]['price'];
      });
    }
    super.initState();
  }
  @override
  void dispose() {
    promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: promoController,
                  decoration: const InputDecoration(
                    
                    contentPadding: EdgeInsets.all(10),
                    hintText: 'Promo Code',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomLeft: Radius.circular(20)),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  if(promoController.text.trim() == widget.promoCode){
                    setState(() {
                      usedPromo = true;
                      discountedPrice = totalPrice * 0.5;
                    });
                    showDialog(context: (context), builder: (context) {
                      return AlertDialog(
                        title: const Text('Promo Code Applied'),
                        content: const Text('Promo code applied successfully'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    });
                  } else {
                    showDialog(context: (context), builder: (context) {
                      return AlertDialog(
                        title: const Text('Invalid Promo code'),
                        content: const Text('The promo code is invalid. Please try again!'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    });
                  }
                  promoController.clear();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(color: Colors.deepOrange, borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)),),
                  child: const Text('Apply', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: widget.cart.length,
            itemBuilder: (context, index) {
              var map = widget.cart;
              return Column(
                children: [
                  CartCard(
                    imageURL: map[index]['imageURL'],
                    name: map[index]['name'],
                    price: map[index]['price'],
                    quantity: map[index]['quantity'].toInt(),
                    size: map[index]['size'].toDouble(),
                    deleteFunction: () => deleteFromCart(index),
                  ),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
        Container(
          height: 70,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${totalPrice.toString()}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25,decoration: usedPromo?TextDecoration.lineThrough:null),
              ),
              (discountedPrice==0)?const SizedBox.shrink():Text(
                '\$${discountedPrice.toString()}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              GestureDetector(
                onTap: () {
                  if(widget.cart.isNotEmpty){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddressPage(cart: widget.cart)));}
                  else {
                    showDialog(context: (context), builder: (context) {
                      return AlertDialog(
                        title: const Text('Empty Cart'),
                        content: const Text('You have no items in your cart'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    });
                  }
                },
                child: Container(
                  height: 50,
                  width: 100,
                  decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                  child: const Center(
                    child: Text(
                      'Confirm',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CartCard extends StatelessWidget {
  final VoidCallback deleteFunction;
  final String imageURL;
  final String name;
  final int price;
  final int quantity;
  final double size;

  const CartCard(
      {Key? key,
      required this.imageURL,
      required this.name,
      required this.price,
      required this.quantity,
      required this.size,
      required this.deleteFunction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: deleteFunction),
              Image.network(imageURL, height: 90, width: 90),
              const SizedBox(width: 10),
              Column(
                children: [
                  Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  Text('Size: $size'),
                  Text('Quantity: $quantity'),
                ],
              )
            ],
          ),
          Text('\$${price.toString()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }
}
