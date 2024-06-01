

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/components/shoecard.dart';
import 'package:ecommerce/pages/cart.dart';
import 'package:ecommerce/pages/delivery.dart';
import 'package:ecommerce/pages/shopping.dart';
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
    List pages = [SelectionPage(cart: cart,),Cart(cart: cart, promoCode: promocode,),SearchProduct(cart: cart),DeliveryUpdate()];
    
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
                onTap: ()=>signOut(),
                leading: Icon(Icons.exit_to_app_rounded,color: Colors.white,),
                title: Text('Sign Out',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
              ListTile(
                onTap: ()=>setState(() {
                  selectedPage = 3;
                  Navigator.of(context).pop();
                }),
                leading: Icon(Icons.update,color: Colors.white,),
                title: Text('Delivery Updates',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Text('SneakerCentre',style: TextStyle(color: Colors.deepOrange,fontSize: 23,fontWeight: FontWeight.bold),),
        actions: [
          IconButton(icon: Icon(Icons.search),onPressed: (){setState(() {
          selectedPage = 2;
        });},),IconButton(icon: Icon(Icons.shopping_bag_rounded),onPressed: (){setState(() {
          selectedPage = 1;
        });},)],),
      body: pages[selectedPage]);
    
  } 
}
class ShoeList extends StatelessWidget {
  final String brand;
  final List cart;

  const ShoeList({Key? key, required this.brand, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                return ShoeCard(title: document['title'], price: document['price'], imageURL: document['imageURL'],cart: cart,);
              },
            );
          }
        },
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
