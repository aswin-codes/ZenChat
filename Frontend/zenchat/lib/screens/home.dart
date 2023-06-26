import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.remove('creds');
                Navigator.pushReplacementNamed(context, '/splash');
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Text(
          "Home",
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
