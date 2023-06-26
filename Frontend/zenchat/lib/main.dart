import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenchat/screens/home.dart';
import 'package:zenchat/screens/login.dart';
import 'package:zenchat/screens/otp.dart';
import 'package:zenchat/screens/otpemail.dart';
import 'package:zenchat/screens/resetpassword.dart';
import 'package:zenchat/screens/signin.dart';
import 'package:zenchat/screens/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Future is not yet complete, show a loading indicator
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          // Error occurred while retrieving SharedPreferences
          return Text('Error: ${snapshot.error}');
        }

        final SharedPreferences prefs = snapshot.data!;

        final String? creds = prefs.getString('creds');

        // Determine the initial route based on login status
        String initialRoute = creds==null? '/splash' : '/';

        // Build the app
        return ScreenUtilInit(
          designSize: const Size(393, 852),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'ZenChat',
               theme: ThemeData(
            primarySwatch: const MaterialColor(
              0xff771f98,
              <int, Color>{
                50: Color(0xff6b1c89), //10%
                100: Color(0xff5f197a), //20%
                200: Color(0xff53166a), //30%
                300: Color(0xff47135b), //40%
                400: Color(0xff3c104c), //50%
                500: Color(0xff300c3d), //60%
                600: Color(0xff24092e), //70%
                700: Color(0xff18061e), //80%
                800: Color(0xff0c030f), //90%
                900: Color(0xff000000), //100%
              },
            ),
            textTheme: Typography.englishLike2018.apply(fontSizeFactor: 1.sp),
          ),
              initialRoute: initialRoute,
              routes: {
                '/splash': (context) => const SplashScreen(),
                '/login': (context) => const Login(),
                '/signin': (context) => const SignIn(),
                '/otpemail': (context) => const OTPEmail(),
                '/otp': (context) => OTP(),
                '/resetpassword': (context) => const ResetPassword(),
                '/': (context) => const Home(),
              },
            );
          },
        );
      },
    );
  }
}