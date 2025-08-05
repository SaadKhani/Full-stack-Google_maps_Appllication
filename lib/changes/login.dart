// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecommerce_app/pages/bottomnav.dart';
// import 'package:ecommerce_app/pages/signup.dart';
// import 'package:ecommerce_app/services/sharedpreference.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/changes/signup.dart';
import 'package:google_maps/google_maps.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? email, password, name;

  final gkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> login() async {
    if (password != null && email != null) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('successfully login')));
        return true;
      } on FirebaseException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('user not found'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        if (e.code == 'wrong-password') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('wrong password'),
              duration: Duration(seconds: 3),
            ),
          );
        }

        return false;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: gkey,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset('assets/maps_log.png'),
                SizedBox(height: 10),
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
                    controller: emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entering your Email is mandatory';
                      } else {
                        return null;
                      }
                    },
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
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Entering your Password is mandatory';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter your password',
                      labelText: 'Password',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'Forgot password',
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
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
                          password = passwordController.text;
                          email = emailController.text;
                        });
                      }

                      // await SharedpreferenceHelper().saveEmail(email!);

                      // var a = await FirebaseFirestore.instance
                      //     .collection('user')
                      //     .get();
                      // for (var element in a.docs) {
                      //   if (element['Email'] == email) {
                      //     name = element['Name'];
                      //   }
                      // }
                      // await SharedpreferenceHelper().saveName(name!);
                      // await SharedpreferenceHelper().saveImage('');

                      await login()
                          .then((value) {
                            if (value) {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      GoogleMapsFlutter(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('login failed')),
                              );
                            }
                          })
                          .catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('some things is wrong')),
                            );
                          });
                      ;
                    },
                    child: Text('Login'),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (Context) => Signup()),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
