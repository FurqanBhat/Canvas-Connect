import 'package:canvas_connect/models/CoursesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import '../shared/loading.dart';

class DiscussionsPage extends StatelessWidget {
  final Course course;
  const DiscussionsPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Discussions",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder(
          future: course.getDiscussions(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Loading();
            }
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Discussion discussion = snapshot.data![index];
                final title = discussion.title;
                final html_desc = discussion.html_description;
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15.0),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    subtitle: Html(
                      data: html_desc,
                      style: {
                        "body": Style(
                          fontSize: FontSize(14.0),
                          color: Colors.black54,
                        ),
                      },
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
