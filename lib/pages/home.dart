

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/pages/cart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String,dynamic>> cart = [];
  String promocode ="ILOVESNEAKERS";
  int selectedPage = 0;
  signOut () async {
    await FirebaseAuth.instance.signOut();
  }
  @override
  
  Widget build(BuildContext context) {
    List pages = [SelectionPage(cart: cart,),Cart(cart: cart, promoCode: promocode,)];
    
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.deepOrange,
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50,),
              const DrawerHeader(child: Text('SneakerCentre',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 35),)),
              
              ListTile(
                leading: const Icon(Icons.home,color: Colors.white,),
                title: const Text('Home',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                onTap: ()=>setState(() {
                  selectedPage = 0;
                  Navigator.pop(context);
                })
                
              ),
              ListTile(
                onTap: ()=>setState(() {
                    selectedPage = 1;  
                    Navigator.pop(context);
                }),
                leading: Icon(Icons.shopping_bag,color: Colors.white,),
                title: Text('Cart',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              ListTile(
                onTap: ()=>signOut(),
                leading: Icon(Icons.exit_to_app_rounded,color: Colors.white,),
                title: Text('Sign Out',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('SneakerCenter',style: TextStyle(color: Colors.deepOrange,fontSize: 30,fontWeight: FontWeight.bold),),centerTitle: true,),
      body: pages[selectedPage]);
    
  } 
}
class ShoeList extends StatelessWidget {
  final String brand;
  final List cart;

  const ShoeList({Key? key, required this.brand, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(brand);
    return Expanded(
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('shoes')
            .where('brand', isEqualTo: brand)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepOrange,));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<QueryDocumentSnapshot>? documents = snapshot.data?.docs;
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: documents?.length ?? 0,
              itemBuilder: (context, index) {
                DocumentSnapshot document = documents![index];
                return FoodCard(title: document['title'], price: document['price'], smallDesc: '', imageURL: document['imageURL'],cart: cart,);
              },
            );
          }
        },
      ),
    );
  }
}
class FoodCard extends StatefulWidget {
  final String title;
  final int price;
  final String smallDesc;
  final String imageURL;
  final List cart;
  const FoodCard({Key? key, required this.title, required this.price, required this.smallDesc, required this.imageURL, required this.cart}) : super(key: key);

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
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
    print(widget.cart);
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
class SelectionPage extends StatefulWidget {
  List<Map<String,dynamic>> cart = [];
  SelectionPage({super.key, required this.cart}); 
  @override
  State<SelectionPage> createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  bool isSelected = false;
  List<String> shoeLinks = ['https://static.vecteezy.com/system/resources/previews/017/339/634/original/puma-transparent-background-free-png.png','https://cdn-icons-png.flaticon.com/512/732/732229.png','https://cdn-icons-png.flaticon.com/512/732/732160.png']; 
  List<String> brands = ['puma','nike','adidas'];
  int selectedBrand = 0;
  List isSelectedBrand = [true,false,false];
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            Container(
              margin: const EdgeInsets.only(left: 10,top: 20,right: 10),
              height: 200,
              width: 350,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [   
                        Text('Get 50% off', style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                        Text('Use PROMO CODE',style: TextStyle(color: Colors.white,fontSize:15)),
                        Text('ILOVESNEAKERS',style: TextStyle(color: Colors.white,fontSize:15))
                      
                    ],
                  ),
                  Image.asset('assets/images/shoes.png',width: 100,height: 100,),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius: BorderRadius.circular(20)
              ),
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: shoeLinks.map((value){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: GestureDetector(
                    onTap: ()=>setState(() {
                      selectedBrand = shoeLinks.indexOf(value);
                      for (int i = 0; i < shoeLinks.length; i++) {
                          isSelectedBrand[i] = (i == selectedBrand);
                      }
                      
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),border: Border.all(color:isSelectedBrand[shoeLinks.indexOf(value)]?Colors.deepOrange: Colors.grey),color:Colors.white),
                      child: Image.network(value,width: 35,height: 35,),),
                  ),
                );
              }).toList()
              
            ),
            const SizedBox(height: 20,),
            ShoeList(brand: brands[selectedBrand],cart: widget.cart,),
          ],
        ),
      );
  }
}
