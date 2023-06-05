import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = '';
  String password = '';
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
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
      body: Stack(
        children: [
          SafeArea(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimateList(
                    interval: 50.ms,
                    effects: [
                      FadeEffect(duration: 200.ms),
                      ScaleEffect(duration: 200.ms)
                    ],
                    children: [
                      SizedBox(
                        height: 60.h,
                      ),
                      Text(
                        "Hello, Welcome Back",
                        style: GoogleFonts.poppins(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      Text(
                        "Happy to see you again, to use your\naccount please login first.",
                        style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 35.h,
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
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Color(0xFF6B6B6B), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.r))),
                          ),
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
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
                                borderSide: const BorderSide(
                                    color: Color(0xFF6B6B6B), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.r))),
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
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFF771F98)),
                                ),
                                onPressed: () {
                                  //Need to fetch request
                                },
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.poppins(
                                      fontSize: 20.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 150.h,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            //Navigate to Sign In Screen
                            Navigator.pushNamed(context, '/signin');
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Don't have an account ? ",
                                style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                "Sign up",
                                style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: const Color(0xFF771F98),
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              right: -25.w,
              top: -22.h,
              child: Transform.rotate(
                angle: 22 * 3 / (7 * 180),
                child: Image.asset(
                  "assets/images/login_illust.png",
                  height: 229.h,
                  width: 188.22.w,
                ),
              ))
        ],
      ),
    );
  }
}
