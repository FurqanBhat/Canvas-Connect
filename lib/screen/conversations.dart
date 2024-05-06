import 'package:canvas_connect/models/conservations_model.dart';
import 'package:canvas_connect/screen/chat_details.dart';
import 'package:canvas_connect/screen/search_screen.dart';
import 'package:flutter/material.dart';

import '../shared/loading.dart';

class Conversations extends StatelessWidget {
  final bool isSent;
  Conversations({Key? key, required this.isSent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Messages',
          style: TextStyle(
            fontSize: 24,
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
              final conversation = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: Text(
                    conversation["participants"][0]["full_name"][0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                title: Text(
                  conversation["subject"] ?? 'No Subject',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  conversation["last_authored_message"] ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                onTap: () => _openChat(context, conversation['id'], conversation["subject"]),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchScreen()));
        },
        label: Text('Start Chat'),
        icon: Icon(Icons.chat),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _openChat(BuildContext context, int id, String subject) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatDetails(id: id, subject: subject)),
    );
  }
}
