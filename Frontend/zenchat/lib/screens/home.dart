import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
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
      body: const Center(
        child: Text(
          "Home",
          style: TextStyle(color: Colors.black),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80.h,
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                topRight: Radius.circular(18.r)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                offset: Offset(0, -4),
                blurRadius: 4.0,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.home_outlined,
                  size: 30.h,
                  color: const Color(0xFF771F98),
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
                icon: Icon(
                  CupertinoIcons.person_add,
                  size: 30.h,
                  color: const Color(0xFF696969),
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.settings_outlined,
                  size: 30.h,
                  color: const Color(0xFF696969),
                )),
          ],
        ),
      ),
    );
  }
}
