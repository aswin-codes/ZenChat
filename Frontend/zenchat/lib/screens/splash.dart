import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int pageIndex = 0;
  late PageController _pageController;
  late Timer _timer;
  int _currentIndex = 0;
  final int _totalPages = 4;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startTimer();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % _totalPages;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 80.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 50.w),
                child: Text(
                  "Get Closer to Everyone",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 36.sp,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "Helps you to contact everyone with\njust easy way",
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: 50.h,
              ),
              SizedBox(
                height: 350.h,
                width: 350.h,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) {
                    setState(() {
                      pageIndex = i;
                    });
                  },
                  pageSnapping: true,
                  children: [
                    Image.asset(
                      "assets/images/illust1.png",
                      height: 350.h,
                      width: 350.h,
                      fit: BoxFit.contain,
                    ),
                    Image.asset(
                      "assets/images/illust2.png",
                      height: 350.h,
                      width: 350.h,
                      fit: BoxFit.contain,
                    ),
                    Image.asset(
                      "assets/images/illust3.png",
                      height: 350.h,
                      width: 350.h,
                      fit: BoxFit.contain,
                    ),
                    Image.asset(
                      "assets/images/illust4.png",
                      height: 350.h,
                      width: 350.h,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: (pageIndex == 0)
                          ? const Color(0xFF8D8D8D)
                          : const Color(0xFFD9D9D9),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 7.h,
                    width: (pageIndex == 0) ? 26.h : 7.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: (pageIndex == 1)
                          ? const Color(0xFF8D8D8D)
                          : const Color(0xFFD9D9D9),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 7.h,
                    width: (pageIndex == 1) ? 26.h : 7.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: (pageIndex == 2)
                          ? const Color(0xFF8D8D8D)
                          : const Color(0xFFD9D9D9),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 7.h,
                    width: (pageIndex == 2) ? 26.h : 7.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: (pageIndex == 3)
                          ? const Color(0xFF8D8D8D)
                          : const Color(0xFFD9D9D9),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    height: 7.h,
                    width: (pageIndex == 3) ? 26.h : 7.h,
                  ),
                ],
              ),
              SizedBox(
                height: 50.h,
              ),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.r),
                  child: SizedBox(
                    height: 45.h,
                    width: 295.w,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF771F98))),
                        onPressed: () {
                          //Need to navigate to next screen
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          "Get Started",
                          style: GoogleFonts.poppins(
                              fontSize: 20.sp,
                              color: const Color(0xFFF3F3F3),
                              fontWeight: FontWeight.w500),
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
