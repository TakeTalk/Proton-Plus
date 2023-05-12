import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});


  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage>{
  List<types.Message> _messages = [];

  String email='';
  String photo='';

  final _user = const types.User(
      id: 'user'
  );
  final _bot = const types.User(
      id: 'proton-plus-bot',
      imageUrl: 'https://raw.githubusercontent.com/TakeTalk/Proton-Plus/main/android/app/src/main/res/mipmap-hdpi/ic_launcher.png?token=GHSAT0AAAAAACA4SW7KUV2CPZAXGGASL5UWZCYWWSQ'
  );

  @override
  void initState() {
    // TODO: implement initState
    _getUserData();
    _getMessage();
    super.initState();
  }

  Future<void> _getUserData() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      email = prefs.getString('email') ?? '';
      photo=prefs.getString('photoUrl')??'';
    });

  }

  @override
  Widget build(BuildContext context) {
        // TODO: implement build
    return Scaffold(
      body: Chat(messages: _messages, onSendPressed: _handleSendPressed, user: _user, showUserAvatars: true,
        onAttachmentPressed: _handleImageSelection,theme:const DarkChatTheme(
        inputBackgroundColor: Color(0xFF000C56),
      ),),
    );
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: 'testing',
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    }
  }

  void _addMessage(types.Message message) {
    _updateMessage(message);
    setState(() {
      _messages.insert(0, message);
    });
  }

  Future<void> _getMessage() async {
    List<types.Message> reversedList=[];

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final email = prefs.getString('email') ?? '';

    var url = Uri.parse('http://43.204.171.36:8989/getChat/$email');

    var response =await http.get(url,headers: { 'Content-type': 'application/json'});

    if(response.statusCode==200){
      var responseList=jsonDecode(response.body) ;
      List<types.Message> tempMsgList = [];

      for(var msg in responseList){
        var user= types.User(id: msg['author']['id']);
        var responseMsg = types.TextMessage(
          author: user,
          showStatus:true,
          createdAt: msg['createdAt'],
          id: msg['id'],
          text: msg['text'],
        );
        tempMsgList.add(responseMsg);
        reversedList = List.from(tempMsgList.reversed);
      }
      setState(() {
        _messages=reversedList;
      });

    }

  }

  Future<void> _updateMessage(types.Message message) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    var url = Uri.parse('http://43.204.171.36:8989/updateChat/$email');

    var body = jsonEncode(message);

    await http.put(url,body: body,headers: { 'Content-type': 'application/json'});

  }

  String formatMessage(String message){
    var msgReply=jsonDecode(message);

    msgReply=msgReply[0];

    if(msgReply["greeting"]!=null){
      return msgReply["greeting"];
    }
    if(msgReply["hospital suggestion"]!=null){
      var suggestHospital=msgReply["hospital suggestion"];
      String reply='Based on your location best hospitals are :\n\n\n';
      int i=0;
      for(var hospital in suggestHospital){
        ++i;
        var h1= "🏥 Hospital $i -> \n\n";
        h1+="🧑‍⚕"+ hospital["name"] + "\n\n📌 Landmark : " + hospital['vicinity'] + "\n\n🗺️ Direction :"+  hospital["link"]+"\n\n\n";
        reply+=h1;
      }
      return reply;

    }
    if(msgReply["appointment"]!=null){
      return msgReply["appointment"];
    }
    if(msgReply["not found"]!=null){
      return msgReply["not found"];
    }

    return "";
  }


  Future<void> _sendMessage(String message) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    var url = Uri.parse('http://43.204.171.36:8989/reply/$email/$message');

    var response = await http.get(url);

    var msgReply=formatMessage(response.body);

    if (response.statusCode == 200) {

      final botRply = types.TextMessage(
        author: _bot,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: msgReply,
      );

      _addMessage(botRply);

    } else {
      print('error');
    }
  }

  void _handleSendPressed(types.PartialText message) {

    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message.text,
    );

    _sendMessage(message.text);

    _addMessage(textMessage);
  }
}

