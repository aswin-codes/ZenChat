import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Search extends StatelessWidget {
  const Search({super.key});

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
                onPressed: () {},
                icon: Icon(
                  CupertinoIcons.person_add,
                  size: 30.h,
                  color: const Color(0xFF771F98),
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.settings_outlined,
                  size: 30.h,
                  color: const Color(0xFF696969),
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
  String query = '';
  TextEditingController _searchController = TextEditingController();

  List<User> _users = [];
  final List<User> _availableUsers = [
    User(
        userName: "Robert Fox",
        email: "robertfox@gmail.com",
        profileID: "402c5163-71bc-4204-92a5-58d1c5e57287.png"),
    User(
        userName: "Esther Howard",
        email: "estherhoward@gmail.com",
        profileID: "402c5163-71bc-4204-92a5-58d1c5e57287.png"),
    User(
        userName: "Jacob Jones",
        email: "jacobjones@gmail.com",
        profileID: "402c5163-71bc-4204-92a5-58d1c5e57287.png"),
    User(
        userName: "Bessie Cooper",
        email: "bessiecooper@gmail.com",
        profileID: null),
  ];

  Future<void> fetchUser() async {
    setState(() {
      query = _searchController.text;
    });
    print(query);
    //final url = Uri.parse('http://10.0.2.2:5000/api/users/search?query=$query');
    //final response = http.get(url);
    setState(() {
      _users = _availableUsers
          .where((element) =>
              element.userName.contains(query) || element.email.contains(query))
          .toList();
    });
    print(_users);
  }

  @override
  void initState() {
    //Intially some random fetch
    _users = _availableUsers;
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
                height: 36.h,
              ),
              SizedBox(
                height: 40.h,
                child: TextField(
                  onChanged: (_) {
                    fetchUser();
                  },
                  controller: _searchController,
                  style:
                      GoogleFonts.poppins(fontSize: 20.sp, color: Colors.black),
                  decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xFF252525),
                        size: 36.h,
                      ),
                      hintText: 'Search Friends',
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 20.sp,
                        color: Color(0xFF252525),
                      ),
                      contentPadding: EdgeInsets.all(3),
                      filled: true,
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius:
                              BorderRadius.all(Radius.circular(14.r))),
                      fillColor: Color(0xFFF1F1F1)),
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _users.length,
                itemBuilder: (BuildContext context, int index) {
                  final User user = _users[index];
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 10.h),
                    margin: EdgeInsets.symmetric(vertical: 15.h),
                    height: 70.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF771F98),
                        width: 2
                      ),
                      borderRadius: BorderRadius.circular(14.r)
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: (user.profileID != null) ? NetworkImage('http://10.0.2.2:5000/${user.profileID}') : null,
                          backgroundColor: Colors.grey,
                          child: (user.profileID == null) ? Icon(Icons.account_circle_outlined, size : 30.h, color: Colors.black,) : null,
                        ),
                        SizedBox(width: 15.w,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user.userName,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF181818),
                                fontSize: 16.sp
                              ),
                            ),
                            Text(
                              user.email,
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF6B6B6B),
                                fontSize: 12.sp
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
              }),
            ],
          )),
    ));
  }
}

class User {
  String userName;
  String email;
  dynamic profileID;
  User({required this.userName, required this.email, required this.profileID});
}
