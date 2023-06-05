import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zenchat/screens/login.dart';
import 'package:zenchat/screens/signin.dart';
import 'package:zenchat/screens/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Set the fit size (Find your UI design, look at the dimensions of the device screen and fill it in,unit in dp)
    return ScreenUtilInit(
      designSize: const Size(393, 852),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ZenChat',
          // You can use the library anywhere in the app even in theme
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
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const Login(),
            '/signin' : (context) => const SignIn()
          },
        );
      },
    );
  }
}
