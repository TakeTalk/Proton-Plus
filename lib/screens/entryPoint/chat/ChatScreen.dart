import 'dart:convert';
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

  Future<void> _sendMessage(String message) async {
    _textController.clear();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';

    var url = Uri.parse('http://43.204.171.36:8989/reply/$email/$message');
    // var headers = {'Content-Type': 'application/json'};
    // var body = jsonEncode({'sentence': message});
    var response = await http.get(url);


    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   content: Text(response.body as String),
    // ));

    if (response.statusCode == 200) {
      setState(() {
        _messages.insert(0, response.body);
        _mymessages.insert(0, message);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   content: Text("name + " " + school2"),
        // ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("name + " " + school3"),
      ));
      _messages.insert(0, 'Failed to send message');
      print('Failed to send message');
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
