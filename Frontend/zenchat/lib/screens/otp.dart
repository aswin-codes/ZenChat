import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;

class OTP extends StatelessWidget {
  const OTP({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
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
      body: Body(
        email: email,
      ),
    );
  }
}

class Body extends StatefulWidget {
  String email;
  Body({super.key, required this.email});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String otp = '';

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

  Future<void> generateOTP() async {
    
    final response = await http.get(
        Uri.parse('http://10.0.2.2:5000/api/generate-otp/${widget.email}'));
    final respBody = jsonDecode(response.body);
    if (response.statusCode == 200 && respBody['success'] == true) {
    } else {
      showAlert(context, respBody['msg']);
    }
  }

  Future<void> checkOTP() async {
    final Map<String, dynamic> body = {"givenOtp": otp};
    final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body));
    final respBody = jsonDecode(response.body);

    if (response.statusCode == 200 && respBody['success'] == true) {
      if (respBody['isOTPCorrect']) {
        Navigator.pushReplacementNamed(context, '/resetpassword',
            arguments: widget.email);
      } else {
        showAlert(context, respBody['msg']);
        await generateOTP();
      }
    } else {
      showAlert(context, respBody['msg']);
    }
  }

  @override
  void initState() {
    generateOTP();
    super.initState();
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
              height: 30.h,
            ),
            SizedBox(
              width: 270.w,
              child: Text(
                "To continue, please enter OTP sent to your email",
                style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Center(
              child: SizedBox(
                width: 300.w,
                child: OTPTextField(
                  length: 4,
                  fieldWidth: 60,
                  style: GoogleFonts.poppins(
                      fontSize: 17.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.underline,
                  onCompleted: (pin) {
                    setState(() {
                      otp = pin;
                    });
                  },
                ),
              ),
            ),
            SizedBox(
              height: 75.h,
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
                        //Need to fetch request
                        checkOTP();
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
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: GestureDetector(
                onTap: () {
                  generateOTP();
                  //Resend OTP
                },
                child: Text(
                  "Resend Code",
                  style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      color: const Color(0xFF771F98),
                      fontWeight: FontWeight.w600),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
