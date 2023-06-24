import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Text("Home", style: TextStyle(color: Colors.black),),
      ),
    );
  }
}