import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_circle_left_outlined,
              color: Colors.black,
              size: 37,
            )),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isVisible = false;
  String password = '';

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

  void showSuccess(BuildContext context, String successMsg) {
    showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: Text(
            "Success...",
            style: GoogleFonts.poppins(
                fontSize: 20.sp,
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold),
          ),
          content: Text(successMsg,
              style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.normal)),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Close the dialog box
                Navigator.pushNamed(context, '/');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> isValid() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final Map<dynamic, dynamic> data = jsonDecode(prefs.getString('creds')!);
      String email = data['email'];
      final Map<String, String> body = {'email': email, 'password': password};
      final url = Uri.parse('http://10.0.2.2:5000/api/verify');
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body));      
      final respBody = jsonDecode(response.body);      
      if (response.statusCode == 200 && respBody['success'] == true) {
        if (respBody['isValid']) {
          Navigator.pushReplacementNamed(context, '/resetpassword');
        } else {
          showAlert(context, respBody['msg']);
        }
      } else {
        showAlert(context, respBody['msg']);
      }
    } catch (err) {
      print("Error validating : $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 31.h,
            ),
            Text(
              "To change password, enter\nyour old password!",
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 31.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, bottom: 7.h),
              child: Text(
                "Password",
                style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
            ),
            SizedBox(
              width: 350.w,
              height: 57.h,
              child: TextField(
                obscureText: !isVisible,
                keyboardType: TextInputType.visiblePassword,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: isVisible
                          ? const Icon(
                              Icons.visibility_off,
                              color: Colors.grey,
                            )
                          : const Icon(
                              Icons.visibility,
                              color: Colors.grey,
                            )),
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xFF6B6B6B), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20.r))),
                ),
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () {
                  //Need to Navigate to Forgot password screen
                  Navigator.pushNamed(context, '/otpemail');
                },
                child: Text(
                  "Forgot Password",
                  style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.normal,
                      color: const Color(0xFF993F3F)),
                ),
              ),
            ),
            SizedBox(
              height: 40.h,
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(15.r)),
                child: SizedBox(
                  height: 45.h,
                  width: 334.w,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(const Color(0xFF771F98)),
                      ),
                      onPressed: () {
                        isValid();
                        //Need to fetch request
                      },
                      child: Text(
                        "Continue",
                        style: GoogleFonts.poppins(
                            fontSize: 20.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
