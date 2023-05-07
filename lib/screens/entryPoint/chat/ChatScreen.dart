import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  List<String> _messages = [], _mymessages = [];

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
    _mymessages.insert(0, message);

    _textController.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    var url = Uri.parse('http://43.204.171.36:8989/reply/$email/$message');
    // var headers = {'Content-Type': 'application/json'};
    // var body = jsonEncode({'sentence': message});
    var response = await http.get(url);

    var msgReply=formatMessage(response.body);



    if (response.statusCode == 200) {
      setState(() {
        _messages.insert(0, msgReply);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("error"),
      ));
      _messages.insert(0, 'Failed to send message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('proton'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                    Align(
                    // align the child within the container
                    alignment:Alignment.centerRight,
                      child: DecoratedBox(
                        // chat bubble decoration
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            _mymessages[index],
                            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                        SizedBox(height: 20),
                      Align(
                      alignment:Alignment.centerLeft,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                        color:Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                        _messages[index],
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color:Colors.black87),
                      ),
                      ),
                      ),
                      )
                      ],
                    )
                );
              },
            ),
          ),
          Divider(),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.0),
                    child: TextField(
                      controller: _textController,
                      onSubmitted: _sendMessage,
                      decoration: InputDecoration(
                        hintText: 'Enter a message',
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_textController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
