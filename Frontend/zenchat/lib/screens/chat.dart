import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zenchat/screens/search.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Chat extends StatefulWidget {
  const Chat({
    super.key,
  });

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final receiverUser = args['user'];
    final IO.Socket socket = args['socket'];
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100.h),
          child: Container(
            padding: EdgeInsets.only(
                top: 50.h, bottom: 30.h, left: 10.w, right: 10.w),
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
                      socket.disconnect();
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
        body: Body(
          receiver: receiverUser,
          socket: socket,
        ));
  }
}

class ChatMessage {
  String text;
  int id;
  DateTime time;
  ChatMessage({required this.id, required this.text, required this.time});
}

class Body extends StatefulWidget {
  final User receiver;
  final IO.Socket socket;
  const Body({super.key, required this.receiver, required this.socket});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _inputController = TextEditingController();
  int id = 0;
  List<ChatMessage> _chatList = [];
  //IO.Socket? socket;

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

  Future<void> getChats() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final Map<dynamic, dynamic> data = jsonDecode(prefs.getString('creds')!);

  setState(() {
    id = data['id'];
  });
  final response = await http.get(Uri.parse(
      'http://10.0.2.2:5000/api/chats/user1/$id/user2/${widget.receiver.id}'));
  final respBody = jsonDecode(response.body);
  if (response.statusCode == 200 && respBody['success'] == true) {
    List<ChatMessage> newChatMessages = []; // Store new chat messages separately

    for (int i = 0; i < respBody['chats'].length; i++) {
      final currentChat = respBody['chats'][i];
      String timestampString = currentChat['timestamp'];

      newChatMessages.add(ChatMessage(
          id: currentChat['sender_id'],
          text: currentChat['message'],
          time: DateTime.parse(timestampString).toLocal()));
    }

    setState(() {
      _chatList.addAll(newChatMessages); // Add new chat messages to _chatList
    });

    // Scroll to the bottom after the state is updated
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
  } else {
    showAlert(context, respBody['msg']);
  }
}

  void addReceiversText(String text) {
    if (mounted) {
      // Check if the widget is still mounted in the tree
      setState(() {
        _chatList.add(ChatMessage(
            id: widget.receiver.id, text: text, time: DateTime.now()));
      });
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        if (mounted) {
          // Check again before scrolling to avoid calling setState on a disposed widget
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  Future<void> addText() async {
    if (_inputController.text != '') {
      setState(() {
        _chatList.add(ChatMessage(
            id: id, text: _inputController.text, time: DateTime.now()));
      });
      widget.socket.emit(
          'chat-message',
          jsonEncode({
            'sender_id': id,
            'receiver_id': widget.receiver.id,
            'message': _inputController.text
          }));
      _inputController.text = '';
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void listenChat() {
    widget.socket.on('new-message', (data) => addReceiversText(data));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    getChats();
    listenChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                        crossAxisAlignment: (id == _message.id)
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
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
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                color: const Color(0xFFF1F1F1),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              '${(_message.time.hour < 10) ? "0" + _message.time.hour.toString() : _message.time.hour}:${(_message.time.minute < 10) ? "0" + _message.time.minute.toString() : _message.time.minute}',
                              style: GoogleFonts.poppins(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
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
    );
  }
}
