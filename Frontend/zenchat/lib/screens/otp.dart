import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OTP extends StatelessWidget {
  const OTP({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: const Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String otp = '';

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
                        Navigator.pushReplacementNamed(context, '/resetpassword');
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
