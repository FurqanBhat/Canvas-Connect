import 'package:flutter/material.dart';
import '../models/conservations_model.dart';
import '../shared/loading.dart';

class ChatDetails extends StatefulWidget {
  final int id;
  final String subject;

  const ChatDetails({Key? key, required this.id, required this.subject})
      : super(key: key);

  @override
  State<ChatDetails> createState() => _ChatDetailsState();
}

class _ChatDetailsState extends State<ChatDetails> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
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
        centerTitle: true,
        title: Text(
          widget.subject,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: ConversationsModel.getFullMessage(widget.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Loading();
                }
                List<dynamic> messages = snapshot.data!["messages"];
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(
                      messages[index]["body"],
                      messages[index]["isFromMe"],
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

  Widget _buildMessage(String message, bool? isFromMe) {
    final backgroundColor =
    isFromMe == true ? Theme.of(context).primaryColor : Colors.grey[300];
    final textColor = isFromMe == true ? Colors.white : Colors.black;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Write your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
            ),
          ),
          SizedBox(width: 8),
          Material(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: () async {
                String body = _controller.text;
                _controller.clear();
                await ConversationsModel.addMessage(widget.id, body);
                setState(() {});
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Icon(Icons.send, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
