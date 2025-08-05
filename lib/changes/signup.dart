import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/changes/login.dart';
import 'package:google_maps/google_maps.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String? name, email, password;
  final gkey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> registeration() async {
    if (name != null && email != null && password != null) {
      try {
        // ignore: unused_local_variable
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email!, password: password!);

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('successfully registered')));

        // Map<String, dynamic> userInfoMap = {
        //   'Name': name,
        //   'Email': email,
        //   'Id': id,
        //   'Image': ''
        // };
        // await DatabaseMethods().addUserDetails(userInfoMap, id);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('password is weak')));
        }
        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Email already existed')));
        }
        log('a : $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: gkey,
          child: Column(
            children: [
              Image.asset(
                height: MediaQuery.of(context).size.height * 0.3,
                'assets/maps_log.png',
              ),
              Text('Sign Up', style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Please Enter the Details below to continue.',
                  style: TextStyle(color: Colors.black26),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 1,
                    ),
                  ],
                  color: Color(0xFFF4F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.only(left: 30, right: 30),
                margin: EdgeInsets.all(15),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entering your name is mandatory';
                    } else {
                      return null;
                    }
                  },
                  controller: nameController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your Name',
                    labelText: 'Name',
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 1,
                    ),
                  ],
                  color: Color(0xFFF4F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.only(left: 30, right: 30),
                margin: EdgeInsets.all(15),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entering your Email is mandatory';
                    } else {
                      return null;
                    }
                  },
                  controller: emailController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your email',
                    labelText: 'Email',
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 1,
                      blurRadius: 1,
                    ),
                  ],
                  color: Color(0xFFF4F5F9),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.only(left: 30, right: 30),
                margin: EdgeInsets.all(15),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Entering your password is mandatory';
                    } else {
                      return null;
                    }
                  },
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your password',
                    labelText: 'Password',
                  ),
                ),
              ),
              Center(
                child: MaterialButton(
                  height: 45,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textColor: Colors.white,
                  minWidth: MediaQuery.of(context).size.width * 0.5,
                  color: Colors.green,
                  onPressed: () async {
                    if (gkey.currentState!.validate()) {
                      setState(() {
                        name = nameController.text;
                        email = emailController.text;
                        password = passwordController.text;
                      });
                      await registeration();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              GoogleMapsFlutter(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    }
                  },
                  child: Text('sign Up'),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? '),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (context) => Login()));
                    },
                    child: Text('Login', style: TextStyle(color: Colors.green)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
