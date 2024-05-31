import 'package:ecommerce/pages/authpage.dart';
import 'package:ecommerce/pages/payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final List selectionItems  = ['Cash On Delivery', 'Credit Card'];
  final locationController = TextEditingController();
  final pincodeController  = TextEditingController();
  final landmarkController = TextEditingController();
  final pincodeValidation = RegExp(r"\b\d{6}\b");
  GlobalKey<FormState> Formkey = GlobalKey();
  String selectedOption = '';

  @override
  void initState() {
    selectedOption = selectionItems.first;// TODO: implement initState
    super.initState();
  }
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Address',style: TextStyle(color: Colors.deepOrange, fontSize: 30, fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: Center(
        child: SafeArea(child: 
        Column(
          children: [
            const SizedBox(height: 20,),
            Form(
              key: Formkey,
              child: Column(children: [
              SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,

                      child: TextFormField(
                        controller: locationController,
                        validator: (value){
                          if(value!.isEmpty) return 'Enter a valid location';
                        },
                        decoration: InputDecoration(
                          
                          
                          contentPadding: const EdgeInsets.all(15),
                          hintText: 'Location',
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
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      
                      child: TextFormField(
                        controller: landmarkController,
                        validator: (value) {
                          if(value!.isEmpty) return 'Enter a valid landmark';
                        },
                       
                        
                        decoration: InputDecoration(
                          
                          
                          contentPadding: const EdgeInsets.all(15),
                          hintText: 'Landmark',
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
                    const SizedBox(height: 10,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                    
                      child: TextFormField(
                        controller: pincodeController,
                        validator: (value) {
                          if(value!.isEmpty || !pincodeValidation.hasMatch(value)) return 'Invalid Pincode Format';
                        },
                        decoration: InputDecoration(  
                          contentPadding: const EdgeInsets.all(15),
                          hintText: 'Pincode',
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
            ],)),
                    const SizedBox(height: 20),
                    GestureDetector(
                onTap: () {
                  if(Formkey.currentState!.validate()) {
                    Formkey.currentState!.save();
                    if(selectedOption == selectionItems[1]) {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>CreditPaymentPage()));
                    }else {
                      showDialog(context: (context), builder: (context) {
                        return AlertDialog(
                          title: Text('Purchase Confirmed!'),
                          content: Text('You have successfully completed the purchase!'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                                  return AuthPage();
                                }), (route) => true);
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        );
                      });
                    }
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 40,
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
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectionItems.length,
                        itemBuilder: (context, index) {
                          return RadioListTile(
                            activeColor: Colors.deepOrange,
                            title: Text(selectionItems[index]),
                            value: selectionItems[index],
                            groupValue: selectedOption,
                            onChanged: (value) {
                              setState(() {
                                selectedOption = value as String;
                              });
                            },
                          );
                        },
                      ),
                    ),

          ],
        )),
      ),
    );
  }
}