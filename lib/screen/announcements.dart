import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

import '../models/CoursesModel.dart';
import '../shared/loading.dart';

class Announcements extends StatelessWidget {
  Course course;
  Announcements({Key? key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Purple color for app bar
        title: Text(
          "Announcements",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: course.getAnnouncements(since: DateTime.now()),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data!.length, // Change this to the number of announcements
            itemBuilder: (context, index) {
              if (!snapshot.hasData) {
                return const Loading();
              }
            Announcement announcement=snapshot.data![index];
              // Mock data for demonstration
              String postedAt = announcement.postedAt.toString();
              DateTime dateTime = DateTime.parse(postedAt);
              String date = DateFormat.d().format(dateTime);
              String dayOfWeek = DateFormat.E().format(dateTime);
              String month = DateFormat.MMM().format(dateTime);
              String title = announcement.title;
              String content = announcement.message;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date box
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent, // Purple color for date box
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                date,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "$dayOfWeek, $month",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        // Announcement details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Html(data: content)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      ),
    );
  }
}
