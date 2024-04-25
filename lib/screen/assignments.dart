import 'package:canvas_connect/models/CoursesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';

import '../shared/loading.dart';

class Assignments extends StatelessWidget {
  Course course;
  Assignments({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xFF0074CC), // CANVAS LMS primary color
        hintColor: Color(0xFFFFC500), // CANVAS LMS hint color
        scaffoldBackgroundColor: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon:  Icon(Icons.arrow_back_outlined),
            onPressed: (){
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Assignments",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body:  FutureBuilder(
            future: course.getAssignments(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Loading();
              }
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Assignment assignment = snapshot.data![index];

                    return _buildAssignmentCard(
                        context,
                        assignment.name,
                        assignment.description,
                        "${DateFormat.MMMd().format(assignment.dueAt)}, ${DateFormat.Hm().format(assignment.dueAt)}",
                        "100",
                        '3',
                        isGraded:false
                    );
                  }
              );
            }
        ),
      ),
    );
  }

  Widget _buildAssignmentCard(
      BuildContext context,
      String title,
      String description,
      String dueDateTime,
      String points,
      String attemptsAllowed,
      {required bool isGraded}
      ) {
    // Splitting the dueDateTime string into date and time components if it contains a comma
    List<String> dateTimeComponents = dueDateTime.split(',');
    String dueDate = dateTimeComponents.length > 1 ? dateTimeComponents[0].trim() : '';
    String dueTime = dateTimeComponents.length > 1 ? dateTimeComponents[1].trim() : '';

    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).primaryColor, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Box for deadline
            Container(
              width: MediaQuery.of(context).size.width * 0.2,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Due',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    dueDate,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    dueTime,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12), // Spacing between deadline box and assignment info
            // Assignment info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Html(data: description,),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            points,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            attemptsAllowed,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      if (isGraded)
                        Text(
                          'Graded',
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).hintColor,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}