import 'package:ecommerce/pages/authpage.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('SneakerCentre',style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
            const SizedBox(height: 20,),
            const Text('Popular brands at affordable prices',style: TextStyle(color: Colors.white,fontSize: 15),),
            const SizedBox(height: 50,),
            GestureDetector(
              onTap: (){Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const AuthPage()));},
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width*0.7,
                decoration: BoxDecoration(color: Colors.deepOrange.shade300,borderRadius: BorderRadius.circular(20)),
                child: const Center(child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Continue',style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                    Icon(Icons.arrow_forward_ios_rounded,color: Colors.white)
                  ],
                )),
              ),
            )
            
      ]),
    ));
  }
}

