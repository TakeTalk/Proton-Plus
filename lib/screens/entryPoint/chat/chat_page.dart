import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage>{
  List<types.Message> _messages = [];

  final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  final _bot = const types.User(id: 'proton-plus-bot');

  @override
  void initState() {
    // TODO: implement initState
    _getMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        // TODO: implement build
    return Scaffold(
      body: Chat(messages: _messages, onSendPressed: _handleSendPressed, user: _user,theme: const DarkChatTheme()),
    );
  }
  //t

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

