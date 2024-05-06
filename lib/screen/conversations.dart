import 'package:canvas_connect/models/conservations_model.dart';
import 'package:canvas_connect/screen/search_screen.dart';
import 'package:flutter/material.dart';

import '../shared/loading.dart';
import 'chat_details.dart';


class Conversations extends StatelessWidget {
  final bool isSent;
  Conversations({Key? key, required this.isSent}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          "Messages",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: ConversationsModel.getConversations(isSent),
        builder: (context, snapshot) {
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
                subtitle: Text(snapshot.data![index]["last_authored_message"] ?? "") ,
                onTap: () => _openChat(context, snapshot.data![index]['id'], snapshot.data![index]["subject"]),
              );
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SearchScreen()));
        } //_startChat(context),
        ,label: Text('Start Chat'),
        icon: Icon(Icons.chat),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }


  void _openChat(BuildContext context, int id, String subject) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatDetails(id: id,subject: subject,)),
    );
  }
}


