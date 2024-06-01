// ignore_for_file: unnecessary_const

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignUp extends StatefulWidget {
  final VoidCallback function;
  const SignUp({super.key, required this.function});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  
  final emailValidation = RegExp(r'^[a-zA-Z0-9. _-]+@[a-zA-Z0-9. -]+\. [a-zA-Z]{2,4}$');
  GlobalKey<FormState> formKey = GlobalKey();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool hidePassword = false;
  bool hidePasswordConfirm = false;
  GlobalKey<FormState> key =GlobalKey();

  Future SignUpFirebase() async {
    try {
      if(_confirmPasswordController.text.trim() ==  _passwordController.text.trim()){
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: const Text('The passwords do not match!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ));
      }
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The password is too weak!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The email is already in use!'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message!),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ));
      }
    }
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final emailValidation =
      RegExp(r'^[a-zA-Z0-9. _-]+@[a-zA-Z0-9. -]+\.[a-zA-Z]{2,4}$');
    
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(child: 
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Text('SneakerCentre',style: TextStyle(color: Colors.deepOrange, fontSize: 35, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 10,),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('Register your account now!',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
            ),
            const SizedBox(height: 10,),
            
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text('SIGN UP',style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),),
            ),
            const SizedBox(height: 50,),
            Form(
              key: formKey,
              child: Center(child: Column(children: [
              SizedBox(
                        width: _width * 0.9,
                        child: TextFormField(
                          validator: (value) {
                            if (emailValidation.hasMatch(value!)) {
                              return null;
                            } else {
                              return 'Invalid email format';
                            }
                          },
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
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
              const SizedBox(height: 30,),
              SizedBox(
                        width: _width * 0.9,
                      
                        child: TextFormField(
                          obscureText: hidePassword,
                          validator: (value) {
                            if(value.toString().length < 8) return 'Password should contain atleast 8 characters';
                          },
                          controller: _passwordController,
                          
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: hidePassword ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                              onPressed: ()=>setState(() {
                                hidePassword = !hidePassword;
                              }),
                            ),
                            
                            contentPadding: const EdgeInsets.all(15),
                            hintText: 'Password',
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
              const SizedBox(height: 30,),
              SizedBox(
                        width: _width * 0.9,
                      
                        child: TextFormField(
                          obscureText: hidePasswordConfirm,
                          validator: (value) {
                            if(value.toString().length < 8) return 'Password should contain atleast 8 characters';
                          },
                          controller: _confirmPasswordController,
                          
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: hidePasswordConfirm ? const Icon(Icons.visibility_rounded) : const Icon(Icons.visibility_off_rounded),
                              onPressed: ()=>setState(() {
                                hidePasswordConfirm = !hidePasswordConfirm;
                              }),
                            ),
                            
                            contentPadding: const EdgeInsets.all(15),
                            hintText: 'Confirm Password',
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
              
              const SizedBox(height: 20),
              
              GestureDetector(
                onTap: (){
                  if(formKey.currentState!.validate()){
                    formKey.currentState!.save();
                    SignUpFirebase();
                    setState(() {
                      _emailController.clear();
                      _passwordController.clear();
                      _confirmPasswordController.clear();
                    });
                  }
                },
                child: Container(
                  width: _width*0.7,
                  height: 60,
                  decoration: BoxDecoration(color: Colors.deepOrange,borderRadius: BorderRadius.circular(20)),
                  child: const Center(child: Text('Submit',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                ),
              ),
              TextButton(onPressed: widget.function, child: const Text('Login to your account'))
              
            ],)))
          ],
        ),
      ),)
    );
  }
}