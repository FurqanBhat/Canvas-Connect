import 'package:canvas_connect/models/conservations_model.dart';
import 'package:flutter/material.dart';

import '../shared/loading.dart';

class Chat {
  final String sender;
  final String message;
  Chat({required this.sender, required this.message});
}

class Conversations extends StatelessWidget {
  Conversations({Key? key}) : super(key: key);

  final List<MyCourse> courses = [
    MyCourse(name: 'Strength', professor: 'Mithat Gokhan', id: null),
    MyCourse(name: 'Thermodynamics 2', professor: 'Cagatay Yilmaz', id: null),
    MyCourse(name: 'Software Engineering', professor: 'Gokhan Bakkal', id: null),
    MyCourse(name: 'Discrete Mathematics', professor: 'Mehmet Tariq', id: null),
    MyCourse(name: 'English 2', professor: 'Yassine Tourane', id: null),
  ];

  final Map<String, List<String>> enrolledStudents = {
    'Strength': ['Furqan Bhat', 'Zohaib Akhtar'],
    'Thermodynamics 2': ['Yassine Oudjana'],
    'Software Engineering': ['Mehmet Bozdan', 'Muhammed Eren'],
    'Discrete Mathematics': ['Omar Ahmed', 'Aise Burak'],
    'English 2': ['Ali Isack', 'Sarah Alhabi', 'Karim Raja', 'Abyan Nadeem', 'Muhammed Eren', 'Zohaib Akhtar'],
  };

  final List<Chat> previousChats = [
    Chat(sender: 'Zohaib Akhtar', message: 'Hey, how are you?'),
    Chat(sender: 'Yassine Oudjana', message: 'Did you understand the assignment?'),
    Chat(sender: 'Furqan Bhat', message: 'Send me the solutions to the homework'),
    Chat(sender: 'Ali Hassan', message: 'Can you help me with the project?'),
  ];

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
        future: ConversationsModel.getConversations(),
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
                  snapshot.data![index]["subject"],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(snapshot.data![index]["last_message"]),
                onTap: () => _openChat(context, snapshot.data![index]['id'], snapshot.data![index]["subject"]),
              );
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => (){} //_startChat(context),
        ,label: Text('Start Chat'),
        icon: Icon(Icons.chat),
        backgroundColor: Colors.blueAccent,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _startChat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var course in courses)
            ListTile(
              title: Text(course.name),
              subtitle: Text(course.professor),
              onTap: () {
                Navigator.pop(context); // Close course selection bottom sheet
                _showStudentsInCourse(context, course);
              },
            ),
        ],
      ),
    );
  }

  void _showStudentsInCourse(BuildContext context, MyCourse course) {
    final students = enrolledStudents[course.name] ?? [];
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var student in students)
            ListTile(
              title: Text(student),
              onTap: () {
                Navigator.pop(context); // Close student selection bottom sheet
                _openChat(context, 676, "");
              },
            ),
        ],
      ),
    );
  }

  void _openChat(BuildContext context, int id, String subject) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage(id: id,subject: subject,)),
    );
  }
}

class MyCourse {
  final String name;
  final String professor;
  final int? id;

  MyCourse({required this.name, required this.professor, this.id});
}

class ChatPage extends StatelessWidget {
  final int id;
  final String subject;

  const ChatPage({Key? key, required this.id, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: ConversationsModel.getFullMessage(id),
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
              decoration: InputDecoration.collapsed(
                hintText: 'Type your message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isSent;

  const ChatMessage({Key? key, required this.message, required this.isSent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSent ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
          message,
          style: TextStyle(color: isSent ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}

