import 'dart:convert';
import 'dart:io';

import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});


  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage>{
  List<types.Message> _messages = [];
  bool isPlaying = false;
  File? immage;
  String? immageName;

  FlutterTts flutterTts=FlutterTts();

  speak(String text) async{
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  final controller = ConfettiController();
  // final _user = const types.User(id: '82091008-a484-4a89-ae75-a22bf8d6f3ac');
  // final _bot = const types.User(id: 'proton-plus-bot');
  String email='';
  String photo='';

  final _user = const types.User(
      id: 'user'
  );
  final _bot = const types.User(
      id: 'proton-plus-bot',
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
      body: Chat(messages: _messages, onSendPressed: _handleSendPressed, user: _user,
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
      immage = File(result.path);
      immageName = result.name;


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

      _getMedicine(result);

    }
  }

  void _getMedicine(var result) async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    var time = DateTime.now().millisecondsSinceEpoch;

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://43.204.171.36:8989/medicineDetect/$email/$time'),
    );

    request.files.add(await http.MultipartFile.fromPath('file', result.path));

    request.send().then((response) {
      if (response.statusCode == 200) {
        var msgRply='';
        response.stream.transform(utf8.decoder).listen((value) {
          final botRply = types.TextMessage(
            author: _bot,
            createdAt: DateTime.now().millisecondsSinceEpoch,
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: formatMessage(value.toString(),1),
          );
          _addMessage(botRply);
        });




      } else {
        throw Exception('Failed to upload file');
      }
    });

  }

  // upload(File imageFile,var stream,var name) async {
  //
  //   // get file length
  //   var length = await imageFile.length();
  //
  //   // string to uri
  //   var uri = Uri.parse("http://ip:8082/composer/predict");
  //
  //   // create multipart request
  //   var request = new http.MultipartRequest("POST", uri);
  //
  //   // multipart that takes file
  //   var multipartFile = new http.MultipartFile('file', stream, length,
  //       filename: name);
  //
  //   // add file to multipart
  //   request.files.add(multipartFile);
  //
  //   // send
  //   var response = await request.send();
  //   print(response.statusCode);
  //
  //   // listen for response
  //   response.stream.transform(utf8.decoder).listen((value) {
  //     print(value);
  //   });
  // }

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

  String formatMessage(String message,int type){
    var msgReply=jsonDecode(message);

    if(type==0) {
      msgReply = msgReply[0];
    }


    if(msgReply["greeting"]!=null){
      speak(msgReply["greeting"]);
      return msgReply["greeting"];
    }
    if(msgReply["hospital suggestion"]!=null){
      var suggestHospital=msgReply["hospital suggestion"];
      String reply='Based on your location best hospitals are :\n\n\n';
      speak(reply);
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
      speak(msgReply["appointment"]);
      return msgReply["appointment"];
    }
    if(msgReply["not found"]!=null){
      speak(msgReply["not found"]);
      return msgReply["not found"];
    }

    if(msgReply["exit"]!=null){
      speak(msgReply["exit"]);
      return msgReply['exit'];
    }

    if(msgReply['this is me']!=null){
      speak(msgReply['this is me']);
      return msgReply['this is me'];
    }

    if(msgReply['order']!=null){
      speak(msgReply['order']);
      return msgReply['order'];
    }

    if(msgReply['cancel']!=null){
      speak(msgReply['cancel']);
      return msgReply['cancel'];
    }

    if(msgReply['medicineSuggestion']!=null){
      var suggestMeds = msgReply["medicineSuggestion"];
      String reply='Detected Medicines are :\n\n\n';
      speak(reply);
      num total=0;
      for(var medicine in suggestMeds){
        var h1= "";
        if(medicine!={}){
          h1+=  medicine["name"] + "\nDosage : " + medicine['time'] + "\nPrice :"+  medicine["price"].toString();
          total+=medicine["price"];
        }
        reply+=h1;
      }
      reply+="\n\n"+"Total Price is "+total.toString();
      reply+="\n\n\n" + "Please confirm and pay the amount";

      return reply;
    }
    return "";
  }


  Future<void> _sendMessage(String message) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

      var url = Uri.parse('http://43.204.171.36:8989/reply/$email/$message');

      var response = await http.get(url);

      var msgReply=formatMessage(response.body,0);

      if (response.statusCode == 200) {

        final botRply = types.TextMessage(
          author: _bot,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: msgReply,
        );

        _addMessage(botRply);

      } else {
        // print('error');
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

