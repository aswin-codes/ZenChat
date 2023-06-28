import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Body(),
      bottomNavigationBar: Container(
        height: 80.h,
        width: double.maxFinite,
        decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18.r),
                topRight: Radius.circular(18.r)),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.1),
                offset: Offset(0, -4),
                blurRadius: 4.0,
              )
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
                icon: Icon(
                  Icons.home_outlined,
                  size: 30.h,
                  color: const Color(0xFF696969),
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
                icon: Icon(
                  CupertinoIcons.person_add,
                  size: 30.h,
                  color: const Color(0xFF696969),
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.settings_outlined,
                  size: 30.h,
                  color: const Color(0xFF771F98),
                )),
          ],
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int id = 0;
  String userName = '';
  String email = '';
  String profilePic = '';
  String base64 = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String imagePath = '';
  final ImagePicker _picker = ImagePicker();
  File? imageFile;

  Future<void> getLocalData() async {
    print('getLocalData called');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<dynamic, dynamic> data = jsonDecode(prefs.getString('creds')!);
    setState(() {
      id = data['id'];
      userName = data['username'];
      email = data['email'];
      profilePic = data['profilepath'];
    });
    try {
      final response =
          await http.get(Uri.parse('http://10.0.2.2:5000/$profilePic'));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        setState(() {
          base64 = base64Encode(bytes);
        });
      }
    } catch (error) {
      print("Error Fetching Image :$error");
    }
  }

  Future<void> LogOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('creds');
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void NameUpdate(BuildContext context) {
    _nameController.text = userName;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Update Name',
            style: TextStyle(color: Color(0xFF771F98)),
          ),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Enter new name'),
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  userName = _nameController.text;
                });

                Navigator.of(context).pop(); // Close the popup
              },
            ),
          ],
        );
      },
    );
  }

  void EmailUpdate(BuildContext context) {
    _emailController.text = email;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Update Email',
            style: TextStyle(color: Color(0xFF771F98)),
          ),
          content: TextField(
            controller: _emailController,
            decoration: const InputDecoration(hintText: 'Enter new name'),
            style: const TextStyle(color: Colors.black),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the popup
              },
            ),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  email = _emailController.text;
                });

                Navigator.of(context).pop(); // Close the popup
              },
            ),
          ],
        );
      },
    );
  }

  void getImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = image!.path;
      imageFile = File(image.path);
    });
    List<int> imageBytes = imageFile!.readAsBytesSync();
    setState(() {
      base64 = base64Encode(imageBytes);
    });
  }

  @override
  void initState() {
    getLocalData();
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
          children: [
            SizedBox(
              height: 130.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 75.r,
                      ),
                      Container(
                        width: 330.w,
                        height: 300.h,
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: const BoxDecoration(
                            color: const Color(0xFFD2D2D2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(13))),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 100.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                NameUpdate(context);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "User Name",
                                    style: GoogleFonts.poppins(
                                        fontSize: 17.sp,
                                        color: const Color(0xFF636363)),
                                  ),
                                  Text(
                                    userName,
                                    style: GoogleFonts.poppins(
                                        fontSize: 17.sp, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            GestureDetector(
                              onTap: () {
                                EmailUpdate(context);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Email ID",
                                    style: GoogleFonts.poppins(
                                        fontSize: 17.sp,
                                        color: const Color(0xFF636363)),
                                  ),
                                  Text(
                                    (email.length > 23)
                                        ? email.substring(0, 20) + "..."
                                        : email,
                                    style: GoogleFonts.poppins(
                                        fontSize: 17.sp, color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            const Divider(
                              color: Colors.black,
                            ),
                            Expanded(
                                child: Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/otpemail');
                                  },
                                  child: Text(
                                    "Change Password",
                                    style: GoogleFonts.poppins(
                                        fontSize: 17.sp,
                                        color: const Color(0xFF771F98)),
                                  )),
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        (imagePath == '')
                            ? CircleAvatar(
                                backgroundColor: const Color(0xFF771F98),
                                radius: 75.r,
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 70.r,
                                  backgroundImage: NetworkImage(
                                      "http://10.0.2.2:5000/$profilePic"),
                                ),
                              )
                            : CircleAvatar(
                                backgroundColor: const Color(0xFF771F98),
                                radius: 75.r,
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 70.r,
                                  backgroundImage: FileImage(imageFile!),
                                ),
                              ),
                        CircleAvatar(
                          backgroundColor: const Color(0xFF771F98),
                          radius: 20.r,
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.black,
                            size: 25.h,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 100.h,
            ),
            SizedBox(
              height: 50.h,
              width: 327.w,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(7.r)),
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Save Changes",
                      style: GoogleFonts.poppins(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: 50.h,
              width: 327.w,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    border:
                        Border.all(color: const Color(0xFF771F98), width: 1.h),
                    borderRadius: const BorderRadius.all(Radius.circular(7))),
                child: TextButton(
                    onPressed: () {
                      LogOut();
                    },
                    child: Text(
                      "Log Out",
                      style: GoogleFonts.poppins(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF771F98)),
                    )),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
