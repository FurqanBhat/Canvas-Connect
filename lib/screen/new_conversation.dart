import 'package:canvas_connect/models/conservations_model.dart';
import 'package:flutter/material.dart';
class NewConversation extends StatefulWidget {
  final String name;
  final int userId;
  const NewConversation({super.key, required this.name, required this.userId});
  @override
  State<NewConversation> createState() => _NewConversationState();
}

class _NewConversationState extends State<NewConversation> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.name,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          title: Text('Send a message'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _subjectController,
                  decoration: InputDecoration(
                    labelText: 'Subject',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a subject';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _bodyController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: 'Body',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a body';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey
                    ),
                    onPressed: () async{
                      if (_formKey.currentState!.validate()) {
                        // Process the form data
                        String subject = _subjectController.text;
                        String body = _bodyController.text;
                        // You can do anything with the data here, like sending it to an API
                        await ConversationsModel.createConversation(widget.userId, subject, body);

                        // Clear the text fields
                        _subjectController.clear();
                        _bodyController.clear();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Submit', style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

