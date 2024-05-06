import 'package:flutter/material.dart';

import '../models/conservations_model.dart';
import '../shared/loading.dart';
class ChatDetails extends StatefulWidget {
  final int id;
  final String subject;

  const ChatDetails({Key? key, required this.id, required this.subject}) : super(key: key);
  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller=TextEditingController();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: ConversationsModel.getFullMessage(widget.id),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Loading();
                }
                return ListView.builder(
                  itemCount: snapshot.data!["messages"].length,
                  itemBuilder: (context, index){
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      child: Card(
                        color: Colors.blueGrey[50],
                        child: Container(
                            padding: EdgeInsets.all(10),
                            child: Text(snapshot.data!["messages"].reversed.toList()[index]["body"])),
                        elevation: 10,
                      ),
                    );
                  },

                );
              },
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(
                hintText: 'Type your message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () async {
              String body=_controller.text;
              _controller.clear();
              await ConversationsModel.addMessage(widget.id, body);
              setState(() {

              });
            },
          ),
        ],
      ),
    );
  }
}