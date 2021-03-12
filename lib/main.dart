import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Taxi"),
          backgroundColor: Colors.amber,
        ),
        body: Center(
          child: Text(
            "Hiba l9arda",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.brown
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){},
          child: Text("+"),
          backgroundColor: Colors.amber,
        ),
      ),
    );
  }
}
