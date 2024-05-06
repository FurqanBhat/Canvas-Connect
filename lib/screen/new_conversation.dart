import 'package:canvas_connect/models/conservations_model.dart';
import 'package:canvas_connect/shared/loading.dart';
import 'package:flutter/material.dart';

class NewConversation extends StatefulWidget {
  final String name;
  final int userId;

  const NewConversation({Key? key, required this.name, required this.userId})
      : super(key: key);

  @override
  State<NewConversation> createState() => _NewConversationState();
}

class _NewConversationState extends State<NewConversation> {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : MaterialApp(
      title: widget.name,
      theme: ThemeData(
        primarySwatch: Colors.blue, // Change this to match the desired primary color
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
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
                    border: OutlineInputBorder(),
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
                    border: OutlineInputBorder(),
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
                      backgroundColor: Theme.of(context).primaryColor, // Change this to match the desired primary color
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        // Process the form data
                        String subject = _subjectController.text;
                        String body = _bodyController.text;
                        // You can do anything with the data here, like sending it to an API
                        await ConversationsModel.createConversation(
                            widget.userId, subject, body);
                        // Clear the text fields
                        _subjectController.clear();
                        _bodyController.clear();
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
