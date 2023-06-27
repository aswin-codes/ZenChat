import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Search extends StatelessWidget {
  const Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Body(),
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
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                icon: Icon(
                  Icons.home_outlined,
                  size: 30.h,
                  color: const Color(0xFF696969),
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.person_add,
                  size: 30.h,
                  color: const Color(0xFF771F98),
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

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String query = '';
  TextEditingController _searchController = TextEditingController();

  void showAlert(BuildContext context, String errorMsg) {
    showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: Text(
            "Error...",
            style: GoogleFonts.poppins(
                fontSize: 20.sp,
                color: Colors.red,
                fontWeight: FontWeight.bold),
          ),
          content: Text(errorMsg,
              style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.normal)),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Close the dialog box
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  List<User> _users = [];

  Future<void> randomUser() async {
    final url = Uri.parse('http://10.0.2.2:5000/api/users/random');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<dynamic, dynamic> respBody = jsonDecode(response.body);
      List<User> data = [];
      for (int i = 0; i < respBody['data'].length; i++) {
        final currentData = respBody['data'][i];
        data.add(User(
            userName: currentData['username'],
            email: currentData['email'],
            profileID: currentData['profilepath']));
      }
      setState(() {
        _users = data;
      });
    } else {
      final Map<dynamic, dynamic> respBody = jsonDecode(response.body);
      showAlert(context, respBody['msg']);
    }
  }

  Future<void> fetchUser() async {
    setState(() {
      query = _searchController.text;
    });

    final url = Uri.parse('http://10.0.2.2:5000/api/users/search?query=$query');
    final response = await http.get(url);
    final Map<dynamic, dynamic> respBody = jsonDecode(response.body);
    if (response.statusCode == 200 && respBody['success'] == true) {
      List<User> data = [];
      for (int i = 0; i < respBody['data'].length; i++) {
        final currentData = respBody['data'][i];
        data.add(User(
            userName: currentData['username'],
            email: currentData['email'],
            profileID: currentData['profilepath']));
      }
      setState(() {
        _users = data;
      });
    } else {
      showAlert(context, respBody['msg']);
    }
  }

  @override
  void initState() {
    randomUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 36.h,
            ),
            SizedBox(
              height: 40.h,
              child: TextField(
                onChanged: (_) {
                  fetchUser();
                },
                controller: _searchController,
                style:
                    GoogleFonts.poppins(fontSize: 20.sp, color: Colors.black),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Color(0xFF252525),
                    size: 36.h,
                  ),
                  hintText: 'Search Friends',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    color: Color(0xFF252525),
                  ),
                  contentPadding: EdgeInsets.all(3),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(14.r)),
                  ),
                  fillColor: Color(0xFFF1F1F1),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Expanded(
              child: (_users.length != 0) ? ListView.builder(
                itemCount: _users.length,
                itemBuilder: (BuildContext context, int index) {
                  final User user = _users[index];
                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 17.w, vertical: 10.h),
                    margin: EdgeInsets.symmetric(vertical: 15.h),
                    height: 70.h,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFF771F98), width: 2),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: (user.profileID != null)
                              ? NetworkImage(
                                  'http://10.0.2.2:5000/${user.profileID}')
                              : null,
                          backgroundColor: Colors.grey,
                          child: (user.profileID == null)
                              ? Icon(
                                  Icons.account_circle_outlined,
                                  size: 30.h,
                                  color: Colors.black,
                                )
                              : null,
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user.userName,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF181818),
                                fontSize: 16.sp,
                              ),
                            ),
                            Text(
                              user.email,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF6B6B6B),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ) : Center(
                child: Text("No users found",
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  color: Colors.black
                ),
                ),
              )
            ),
        
          ],
        ),
      ),
    );
  }
}

class User {
  String userName;
  String email;
  dynamic profileID;
  User({required this.userName, required this.email, required this.profileID});
}
