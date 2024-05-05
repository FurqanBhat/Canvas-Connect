import 'package:flutter/material.dart';

class Chat {
  final String sender;
  final String message;

  Chat({required this.sender, required this.message});
}

class discussion extends StatelessWidget {
  discussion({Key? key}) : super(key: key);

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
      body: ListView.builder(
        itemCount: previousChats.length,
        itemBuilder: (BuildContext context, int index) {
          final chat = previousChats[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(chat.sender[0]),
            ),
            title: Text(
              chat.sender,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(chat.message),
            onTap: () => _openChat(context, chat.sender),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startChat(context),
        label: Text('Start Chat'),
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
                _openChat(context, student);
              },
            ),
        ],
      ),
    );
  }

  void _openChat(BuildContext context, String student) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatPage(student: student)),
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
  final String student;

  const ChatPage({Key? key, required this.student}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(student),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ChatMessage(message: 'Hey, how are you?', isSent: false),
                ChatMessage(message: 'I am good, thanks!', isSent: true),
                ChatMessage(message: 'Do you have the homework solutions?', isSent: true),
              ],
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

