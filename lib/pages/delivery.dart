import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DeliveryUpdate extends StatelessWidget {
  const DeliveryUpdate({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [Text('Delivery Updates',style: TextStyle(color: Colors.black, fontSize: 25,fontWeight: FontWeight.bold),)],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              builder: (context,snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if(snapshot.hasError) {
                return const Center(child: Text('An error has occured, please try again later!'),);
              } else if(!snapshot.hasData) {
                return const Center(child: Text('You have no upcoming deliveries'));
            
              } else {
                print(snapshot.data!.docs);
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index) {
                    return DeliveryCard(numProduct: snapshot.data!.docs[index]['products'], landmark: snapshot.data!.docs[index]['landmark'], location: snapshot.data!.docs[index]['location'], pincode: snapshot.data!.docs[index]['pincode'], date: snapshot.data!.docs[index]['when'],deliveryDate: snapshot.data!.docs[index]['deliveryDate'],cashOnDelivery: snapshot.data!.docs[index]['isCOD'],); 
                  });
              }
            },future: FirebaseFirestore.instance.collection('delivery').doc(user!.uid).collection(user.uid).where('isDelivered',isEqualTo: false).get(),),
          ),
        ],
      ),
    );
  }
}
class DeliveryCard extends StatelessWidget {
  final bool cashOnDelivery;
  final Timestamp date;
  final num numProduct;
  final Timestamp deliveryDate;
  final String landmark;
  final String location;
  final String pincode;
  const DeliveryCard({super.key, required this.numProduct, required this.landmark, required this.location, required this.pincode, required this.date, required this.deliveryDate, required this.cashOnDelivery});

  @override
  Widget build(BuildContext context) {
    int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.deepOrange,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Date: ${date.toDate()}',style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
          Text('Products: $numProduct',style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
          Text('Landmark: $landmark',style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
          Text('Location: $location',style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
          Text('Pincode: $pincode',style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
          Text('Payment: ${cashOnDelivery? 'Cash On Delivery' : 'Credit Card'}',style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),),
          const Text(''),
          Text('Your product will arrive in ${daysBetween(DateTime.now(), deliveryDate.toDate())} days!',style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
        ],
      ),
      
    );
  }
}