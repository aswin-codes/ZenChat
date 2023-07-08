import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:http/http.dart' as http;
import 'package:zenchat/screens/search.dart';

class Home extends StatelessWidget {
  IO.Socket socket = IO.io(
      'http://10.0.2.2:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build());

  Future<void> connectToServer() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<dynamic, dynamic> data = jsonDecode(prefs.getString('creds')!);
    final id = data['id'];
    socket.connect();
    socket.onConnect((_) {
      print('Connected to server');

      socket.emit('new-user', jsonEncode({'id': id}));

      socket.on('chat-message', (data) {
        print('Received chat message: $data');
      });
    });

    socket.onConnectError((error) {
      print('Connection error: $error');
    });
  }

  Home({super.key}) {
    connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Body(
        socket: socket,
      ),
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
                onPressed: () {},
                icon: Icon(
                  Icons.home_outlined,
                  size: 30.h,
                  color: const Color(0xFF771F98),
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/search', arguments: socket);
                },
                icon: Icon(
                  CupertinoIcons.person_add,
                  size: 30.h,
                  color: const Color(0xFF696969),
                )),
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
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
  IO.Socket socket;
  Body({super.key, required this.socket});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool isLoading = true;
  List<ChatUser> _users = [];
  List<ChatUser> _chatList = [];

  void showAlert(BuildContext context, String errorMsg) {
    showDialog(
      context: context,
      builder: (
        BuildContext context,
      ) {
        return AlertDialog(
          title: Text(
            "Error...",
            style: GoogleFonts.poppins(
                fontSize: 20.sp,
                color: Colors.red,
                fontWeight: FontWeight.bold),
          ),
          content: Text(errorMsg,
              style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  color: Colors.black,
                  fontWeight: FontWeight.normal)),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                // Close the dialog box
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> getChatList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final Map<dynamic, dynamic> data = jsonDecode(prefs.getString('creds')!);
      final id = data['id'];
      final url = Uri.parse('http://10.0.2.2:5000/api/chatlist/$id');
      final response = await http.get(url);
      final respBody = jsonDecode(response.body);
      setState(() {
        isLoading = false;
      });
      if (response.statusCode == 200 && respBody['success']) {
        List<ChatUser> data = [];
        for (int i = 0; i < respBody['chatlist'].length; i++) {
          data.add(ChatUser(
              id: respBody['chatlist'][i]['id'],
              email: respBody['chatlist'][i]['email'],
              userName: respBody['chatlist'][i]['username'],
              imagePath: respBody['chatlist'][i]['profilepath'],
              latestText: respBody['chatlist'][i]['message'],
              timeStamp: DateTime.parse(respBody['chatlist'][i]['timestamp'])
                  .toLocal()));
        }
        setState(() {
          _chatList = data;
          _users = data;
        });
      } else {
        showAlert(context, respBody['msg']);
      }
    } catch (err) {
      print(err);
    }
  }

  void searchUser(_) {
    final searchTerm = _.toLowerCase();
    if (_ != '') {
      setState(() {
        _chatList = _users
            .where((user) =>
                user.userName.toLowerCase().contains(searchTerm) ||
                user.email.toLowerCase().contains(searchTerm))
            .toList();
      });
    } else {
      setState(() {
        _chatList = _users;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getChatList();
    super.initState();
  }

  final TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                searchUser(_);
              },
              controller: _searchController,
              style: GoogleFonts.poppins(fontSize: 20.sp, color: Colors.black),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFF252525),
                  size: 36.h,
                ),
                hintText: 'Search Chat',
                hintStyle: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  color: Color(0xFF252525),
                ),
                contentPadding: EdgeInsets.all(3),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(Radius.circular(14.r)),
                ),
                fillColor: Color(0xFFF1F1F1),
              ),
              onSubmitted: (_) {
                searchUser(_);
              },
            ),
          ),
          SizedBox(
            height: 30.h,
          ),
          Expanded(
            child: (isLoading)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : (_chatList.length != 0)
                    ? ListView.builder(
                        itemCount: _chatList.length,
                        itemBuilder: (BuildContext context, int index) {
                          ChatUser user = _chatList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/chat',
                                  arguments: {
                                    'user': User(
                                      id: user.id,
                                      email: user.email,
                                      profileID: user.imagePath,
                                      userName: user.userName),
                                    'socket' : widget.socket
                                  });
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 17.w, vertical: 10.h),
                                margin: EdgeInsets.symmetric(vertical: 15.h),
                                height: 70.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color(0xFF771F98), width: 2),
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: (user.imagePath !=
                                                  null)
                                              ? NetworkImage(
                                                  'http://10.0.2.2:5000/${user.imagePath}')
                                              : null,
                                          backgroundColor: Colors.grey,
                                          child: (user.imagePath == null)
                                              ? Icon(
                                                  Icons.account_circle_outlined,
                                                  size: 30.h,
                                                  color: Colors.black,
                                                )
                                              : null,
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              user.userName,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                color: const Color(0xFF181818),
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                            Text(
                                              user.latestText,
                                              style: GoogleFonts.poppins(
                                                color: const Color(0xFF6B6B6B),
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        '${(user.timeStamp.hour < 10) ? "0" + user.timeStamp.hour.toString() : user.timeStamp.hour}:${(user.timeStamp.minute < 10) ? "0" + user.timeStamp.minute.toString() : user.timeStamp.minute}',
                                        style: GoogleFonts.poppins(
                                            color: const Color(0xFF5C5C5C),
                                            fontSize: 11,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    )
                                  ],
                                )),
                          );
                        })
                    : Center(
                        child: Text(
                          "No users found",
                          style: GoogleFonts.poppins(
                              fontSize: 15.sp, color: Colors.grey),
                        ),
                      ),
          )
        ],
      ),
    ));
  }
}

class ChatUser {
  String userName;
  String? imagePath;
  String email;
  int id;
  String latestText;
  DateTime timeStamp;
  ChatUser(
      {required this.id,
      required this.email,
      required this.userName,
      required this.imagePath,
      required this.latestText,
      required this.timeStamp});
}
