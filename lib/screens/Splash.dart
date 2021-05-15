import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taxi_ma/screens/home/HomePage.dart';
import 'MainPage.dart';
import 'LoginPage.dart';
class Splash extends StatefulWidget {
  @override
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> {
  _Splash(){
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User user) {
      if (user == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => MainPage()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => MainPage()));
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  "TAXI LIK",
                style: TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 50,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 20),
              Icon(
                Icons.directions_car,
                color: Colors.amber,
                size: 50,
              ),
              SizedBox(height: 10),
              SpinKitWave(
                color: Colors.amber,
                size: 50.0,

              ),
            ],
          ),
        ),
    );
  }
}