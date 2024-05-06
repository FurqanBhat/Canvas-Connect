import 'package:canvas_connect/screen/new_conversation.dart';
import 'package:flutter/material.dart';

import '../models/conservations_model.dart';
import '../shared/loading.dart';
import 'chat_details.dart';
class SingleConversation extends StatefulWidget {
  final String name;
  final int id;
  const SingleConversation({super.key, required this.name, required this.id});

  @override
  State<SingleConversation> createState() => _SingleConversationState();
}

class _SingleConversationState extends State<SingleConversation> {
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
        title: Text(widget.name),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              setState(() {
                
              });
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          "Create New Conversation"
        ),
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NewConversation(name: widget.name, userId: widget.id)));
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: ConversationsModel.getSingleConversation(widget.id),
              builder: (context, snapshot){
                if (!snapshot.hasData) {
                  return const Loading();
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(snapshot.data![index]["participants"][0]["full_name"][0]),
                      ),
                      title: Text(
                        snapshot.data![index]["subject"] ?? "No Subject",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(snapshot.data![index]["last_authored_message"] ?? ""),
                      onTap: () => _openChat(context, snapshot.data![index]['id'], snapshot.data![index]["subject"]),
                    );
                  },
                );
              },
            ),
          ),

        ],
      ),
    );
  }

  // Widget _buildInputField() {
  //   return Container(
  //     padding: EdgeInsets.symmetric(horizontal: 8.0),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[200],
  //       borderRadius: BorderRadius.circular(20.0),
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(
  //           child: TextField(
  //             controller: _controller,
  //             decoration: InputDecoration.collapsed(
  //               hintText: 'Type your message...',
  //             ),
  //           ),
  //         ),
  //         IconButton(
  //           icon: Icon(Icons.send),
  //           onPressed: () async{
  //             await ConversationsModel.createConversation(widget.id, widget.name, _controller.text);
  //             _controller.clear();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
  void _openChat(BuildContext context, int id, String subject) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatDetails(id: id,subject: subject,)),
    );
  }
}

