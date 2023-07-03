import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenchat/screens/search.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputController = TextEditingController();
  int id = 0;
  String userName = '';
  String email = '';
  String profilePic = '';

  List<ChatMessage> _chatList = [
    ChatMessage(id: 42, text: "Hi", time: DateTime(2020, 1, 1, 6, 45)),
    ChatMessage(id: 50, text: "Hello", time: DateTime(2020, 1, 1, 6, 45)),
    ChatMessage(
        id: 42, text: "How are you ?", time: DateTime(2020, 1, 1, 6, 45)),
    ChatMessage(id: 50, text: "I'm fine", time: DateTime(2020, 1, 1, 6, 45)),
    ChatMessage(
        id: 42, text: "How about you ?", time: DateTime(2020, 1, 1, 6, 45)),
    ChatMessage(id: 50, text: "I am good", time: DateTime(2020, 1, 1, 6, 45)),
    ChatMessage(id: 42, text: "ok bye", time: DateTime(2020, 1, 1, 6, 45)),
    ChatMessage(id: 50, text: "yeah bye", time: DateTime(2020, 1, 1, 6, 45))
  ];

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
  }

  Future<void> addText() async {
    if (_inputController.text != '') {
      setState(() {
        _chatList.add(ChatMessage(
            id: 42, text: _inputController.text, time: DateTime.now()));
      });
      _inputController.text = '';
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    getLocalData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final receiverUser = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.h),
        child: Container(
          padding:
              EdgeInsets.only(top: 50.h, bottom: 30.h, left: 10.w, right: 10.w),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 4,
                    offset: Offset(0, 4),
                    color: Color.fromRGBO(0, 0, 0, 0.25)),
              ]),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    size: 20,
                  )),
              SizedBox(
                width: 13.w,
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(
                    'http://10.0.2.2:5000/${receiverUser.profileID}'),
                radius: 25.r,
              ),
              SizedBox(
                width: 13.w,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receiverUser.userName,
                    style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    receiverUser.email,
                    style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        color: const Color(0xFF6B6B6B),
                        fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: _scrollController,
                    itemCount: _chatList.length,
                    itemBuilder: (BuildContext context, int index) {
                      ChatMessage _message = _chatList[index];
                      return Align(
                        alignment: (id == _message.id)
                            ? Alignment.topRight
                            : Alignment.topLeft,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              constraints: BoxConstraints(maxWidth: 300.w),
                              decoration: BoxDecoration(
                                  color: (id == _message.id)
                                      ? const Color(0xFF771F98)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: (id == _message.id)
                                      ? null
                                      : Border.all(
                                          width: 2,
                                          color: const Color(0xFF771F98))),
                              child: Text(
                                _message.text,
                                style: GoogleFonts.poppins(
                                    color: (id == _message.id)
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF1F1F1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text('${_message.time.minute}:'),
                            )
                          ],
                        ),
                      );
                    }),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(18.r),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, -4),
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _inputController,
                        decoration: InputDecoration(
                          hintText: "Type here...",
                          hintStyle: GoogleFonts.poppins(
                            color: const Color(0xFF8D8D8D),
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.poppins(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                        onSubmitted: (_) {
                          addText();
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        // Send button pressed...
                        addText();
                        FocusScope.of(context).unfocus();
                      },
                      icon: Icon(
                        Icons.send,
                        color: const Color(0xFF771F98),
                        size: 25.h,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  String text;
  int id;
  DateTime time;
  ChatMessage({required this.id, required this.text, required this.time});
}
