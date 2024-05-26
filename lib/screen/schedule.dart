import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:canvas_connect/models/CoursesModel.dart';
import 'package:canvas_connect/shared/database_manager.dart';
import 'package:canvas_connect/shared/loading.dart';

Widget constructDaySchedule(int weekday, bool today, List<int> courseIds)
{
  return Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      /* 1970-01-04 is a Sunday, adding weekday to it gives the corresponding weekday */
      today ? "Today" : DateFormat.EEEE().format(DateUtils.addDaysToDate(DateTime.parse("1970-01-04"), weekday)),
      style: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.w100
      ),
    ),
    const SizedBox(height: 4.0),
    FutureBuilder(
      future: DatabaseManager.getSessions(
        courseIds: courseIds,
        dayOfWeek: weekday
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Loading();
        }

        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No sessions",
              style: TextStyle(
                fontSize: 18.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w100,
                color: Colors.grey
              ),
            ),
          );
        }

        return Column(
          children: List<Widget>.generate(
            snapshot.data!.length,
            (index) {
              Session session = snapshot.data![index];
              Course course = CoursesModel.activeCourses[0];

              for (course in CoursesModel.activeCourses) {
                if (course.id == session.courseId) {
                  break;
                }
              }

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  toBeginningOfSentenceCase(course.code),
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  course.name,
                                  style: const TextStyle(
                                    fontSize: 8.0
                                  ),
                                )
                              ],
                            ),
                          ),
                          Text(
                            "${DateFormat.jm().format(session.startTime)} - ${DateFormat.jm().format(session.endTime)}",
                            style: const TextStyle(
                              fontSize: 14.0,
                            )
                          ),
                        ],
                      ),
                      if (session.location != null) const SizedBox(height: 4.0),
                      if (session.location != null) Row(
                        children: [
                          Expanded(
                            child: Text(
                              session.location!.roomCode,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontFamily: "monospace"
                              )
                            ),
                          ),
                          Text(
                            "${session.location!.buildingName}${session.location!.roomName != null ? "\n${session.location!.roomName}" : ""}",
                            style: const TextStyle(
                              fontSize: 16.0,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w100
                            ),
                            textAlign: TextAlign.end,
                          )
                        ]
                      )
                    ],
                  ),
                ),
              );
            }
          )
        );
      }
    ),
    const SizedBox(height: 4.0),
    ],
  );
}

class Schedule extends StatelessWidget
{
  const Schedule({super.key});

  @override
  Widget build(BuildContext context) 
  {
    List<int> courseIds = [];

    for (Course course in CoursesModel.activeCourses) {
      courseIds.add(course.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Schedule',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: List<Widget>.generate(
            7,
            (index) {
              if (index == 0) {
                return constructDaySchedule(DateTime.now().weekday, true, courseIds);
              }

              /* Construct schedules for all days */
              return constructDaySchedule(index, false, courseIds);
            }
          )
        )
      )
    );
  }
}
