import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key});

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
  String password = '';
  String cpassword = '';

  bool isVisible = false;
  bool isVisible1 = false;
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
            Text(
              "Forgot Password",
              style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              "Enter the new password",
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: 15.h,
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
                style: TextStyle(color: Colors.black),
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: Icon(
                        isVisible ? Icons.visibility_off : Icons.visibility,
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
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, bottom: 7.h),
              child: Text(
                "Confirm Password",
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
                obscureText: !isVisible1,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible1 = !isVisible;
                        });
                      },
                      icon: Icon(
                        isVisible1 ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      )),
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Color(0xFF6B6B6B), width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20.r))),
                ),
                onChanged: (value) {
                  setState(() {
                    cpassword = value;
                  });
                },
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
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        "Change Password",
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
