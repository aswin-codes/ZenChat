import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

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
  String imagePath = '';
  final ImagePicker _picker = ImagePicker();
  late File imageFile;

  String fullName = '';
  String email = '';
  String password = '';
  String cpassword = '';

  bool isVisible = false;
  bool isVisible1 = false;

  void getImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = image!.path;
      imageFile = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              Text(
                "Sign In",
                style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              Text(
                "Create an account to use our versatile chatting app.",
                style: GoogleFonts.poppins(
                    fontSize: 15.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 10.h,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    getImage();
                  },
                  child: (CircleAvatar(
                    radius: 45.r,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        (imagePath == '') ? null : FileImage(File(imagePath)),
                    child: (imagePath == '')
                        ? Icon(
                            Icons.account_circle_rounded,
                            color: Colors.black,
                            size: 90.r,
                          )
                        : null,
                  )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.w, bottom: 7.h),
                child: Text(
                  "Full Name",
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
                  keyboardType: TextInputType.name,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF6B6B6B), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(20.r))),
                  ),
                  onChanged: (value) {
                    setState(() {
                      fullName = value;
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
                        borderSide: const BorderSide(
                            color: Color(0xFF6B6B6B), width: 1),
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
                height: 20.h,
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
                        borderSide: const BorderSide(
                            color: Color(0xFF6B6B6B), width: 1),
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
                        borderSide: const BorderSide(
                            color: Color(0xFF6B6B6B), width: 1),
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
                height: 50.h,
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
                          "Sign In",
                          style: GoogleFonts.poppins(
                              fontSize: 20.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Center(
                child: GestureDetector(
                  onTap: () {
                    //Navigate to Sign In Screen
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Already have an account ? ",
                        style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        "Login",
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
    ));
  }
}
