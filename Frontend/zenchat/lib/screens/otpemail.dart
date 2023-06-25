import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class OTPEmail extends StatelessWidget {
  const OTPEmail({super.key});

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
  String email = '';

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
                "To continue, please enter your email ID",
                style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, bottom: 7.h),
              child: Text(
                "Email Address",
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
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xFF6B6B6B), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20.r))),
                ),
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 70.h,
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
                        Navigator.pushNamed(context, '/otp');
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
