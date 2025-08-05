import 'package:flutter/material.dart';
import 'package:google_maps/changes/login.dart';
import 'package:google_maps/changes/signup.dart';

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      backgroundColor: Color(0xffecefe8),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              fit: BoxFit.contain,
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.35,
              'assets/maps_img.jpg',
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Explore\nthe map\nwith us',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: MaterialButton(
                  height: 50,
                  elevation: 3,
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (context) => Signup()));
                  },
                  child: Text(
                    'No Account? Click here to create one',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: MaterialButton(
                  height: 50,
                  elevation: 3,
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(
                      context,
                    ).push(MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    'Already Account? Click here to Login',
                    style: TextStyle(color: Colors.white),
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
