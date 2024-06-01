import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/components/shoecard.dart';
import 'package:ecommerce/pages/home.dart';
import 'package:flutter/material.dart';

class SearchProduct extends StatefulWidget {
  final List cart;
  SearchProduct({super.key, required this.cart});

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  final searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SafeArea(child: 
      Center(child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width*0.9,
            child: SearchBar(
              controller: searchController,
              leading: const Icon(Icons.search),
              hintText: 'Search',
            ),
          ),
          const SizedBox(height: 20,),
          Expanded(
            child: FutureBuilder(future: FirebaseFirestore.instance.collection('shoes').where('title',isGreaterThanOrEqualTo: searchController.text.trim()).where('title',isLessThanOrEqualTo: searchController.text.trim() + '~').get(), builder:((context, snapshot) {
              if(snapshot.connectionState ==  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(),);
              } else if (snapshot.hasError) {
                return const Center(child: Text('An error has occured, try again later!'),);
             } else {
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: ((context, index) {
                return ShoeCard(title: snapshot.data!.docs[index]['title'], price: snapshot.data!.docs[index]['price'], imageURL: snapshot.data!.docs[index]['imageURL'], cart: widget.cart);
              }));
             }
            })),
          )
        ]
        ,

      ),)),
    );
  }
}
