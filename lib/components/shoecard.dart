import 'package:flutter/material.dart';

class ShoeCard extends StatefulWidget {
  final String title;
  final int price;
  final String imageURL;
  final List cart;
  const ShoeCard({Key? key, required this.title, required this.price, required this.imageURL, required this.cart}) : super(key: key);

  @override
  State<ShoeCard> createState() => _ShoeCardState();
}

class _ShoeCardState extends State<ShoeCard> {
  List<bool> isSelected = [false,false,false,false];
  int numItems = 1;
  double selectedSize = 0;

  addToCart() {
    Map<String, dynamic> map = {
      'imageURL': widget.imageURL,
      'name': widget.title,
      'price':widget.price*numItems,
      'quantity':numItems,
      'size':selectedSize,
    };
    setState(() {
      widget.cart.add(map);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to cart!', style: TextStyle(color: Colors.white),),
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    List<double> sizes = [6,6.5,7,7.5];
    return Container(
      margin: const EdgeInsets.only(left: 10,bottom: 20, right: 10),
      padding: const EdgeInsets.all(10),

      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              widget.imageURL,
              width: 300,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: ()=>setState(() {
                        if(numItems>1) numItems--;
                      }),
                      child: Container(decoration: const BoxDecoration(color: Colors.black),child: const Icon(Icons.remove,color: Colors.white,),)),
                    Text(numItems.toString()),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          numItems++;
                        });
                      },
                      child: Container(child: const Icon(Icons.add,color: Colors.white,),decoration: const BoxDecoration(color: Colors.black),))
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: sizes.map(
                  (size) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSize = size;
                          isSelected[sizes.indexOf(size)] =!isSelected[sizes.indexOf(size)];
                          for (int i = 0; i < sizes.length; i++) {
                              isSelected[i] = (i == sizes.indexOf(size));
                          }
                          
                        });
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(color: isSelected[sizes.indexOf(size)]?Colors.black:Colors.white,borderRadius: BorderRadius.circular(50),border: Border.all(color: Colors.black)),
                        child: Text(size.toString(), textAlign: TextAlign.center, style: TextStyle(color: isSelected[sizes.indexOf(size)]?Colors.white:Colors.black),),
                      ),
                    );
                  }
                ).toList(),),
              ),
              const SizedBox(height: 20,),
              SizedBox(
                
                width: 300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25), ),
                        Text('\$${widget.price.toString()}'),

                        
                      ],),
                      GestureDetector(
                        onTap: ()=>addToCart(),
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.add, color: Colors.white,)
                        ),
                      )
                      
                  ],
                ),
              ),
            ],
          )
          
        ],
      ),
    );
  }
}