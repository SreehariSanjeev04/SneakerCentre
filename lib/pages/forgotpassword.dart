// ignore_for_file: unnecessary_const

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final _emailController = TextEditingController();
    final emailValidation =
      RegExp(r'^[a-zA-Z0-9. _-]+@[a-zA-Z0-9. -]+\.[a-zA-Z]{2,4}$');
    GlobalKey<FormState> formKey = GlobalKey();

    Future sendResetToEmail(String email) async {
    try {
      showDialog(context: (context), builder: (context) {
        return const Center(child: CircularProgressIndicator());
      });
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reset link has been sent to your email'),behavior: SnackBarBehavior.floating,backgroundColor: Colors.green,));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),behavior: SnackBarBehavior.floating, backgroundColor: Colors.red,));
    }
  }
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            const Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Forgot Password',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 30,),
            Form(
              key: formKey,
              child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          validator: (value) {
                            if(emailValidation.hasMatch(value!)) return null;
                            else return 'Invalid email format';
                          },
                          controller: _emailController,
                          
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            hintText: 'Email',
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
            ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          sendResetToEmail(_emailController.text.trim());
                          
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
    );
  }
}