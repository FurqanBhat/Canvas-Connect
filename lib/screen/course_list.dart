import 'package:canvas_connect/models/LoginModel.dart';
import 'package:canvas_connect/resource/theme.dart';
import 'package:canvas_connect/screen/all_courses.dart';
import 'package:canvas_connect/screen/announcements.dart';
import 'package:canvas_connect/screen/assignments.dart';
import 'package:canvas_connect/screen/course_screen.dart';
import 'package:canvas_connect/screen/conversations.dart';
import 'package:canvas_connect/screen/login_screen.dart';
import 'package:canvas_connect/models/CoursesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CourseList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Courses"),
        ),
        drawer: Drawer(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade800,
                ),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Canvas-Connect",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log out"),
              onTap: () {
                LoginModel.logOut();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const LoginScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_copy_sharp),
              title: const Text("All courses"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AllCourses()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text("Inbox"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Conversations(isSent: false)));
              },
            ),
            ListTile(
              leading: const Icon(Icons.message_outlined),
              title: const Text("Outbox"),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Conversations(isSent: true)));
              },
            ),
          ],
        )),
        body: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: CoursesModel.activeCourses.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Material(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  elevation: 4.0,
                  color: Theme.of(context).cardColor,
                  child: InkWell(
                    child: SizedBox(
                        height: 72.0,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 24.0,
                              child: Container(
                                color: CoursesModel.activeCourses[index].color,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    CoursesModel.activeCourses[index].code,
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w200),
                                  ),
                                  Text(CoursesModel.activeCourses[index].name,
                                      style: const TextStyle(
                                        fontSize: 10.0,
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Row(children: [
                              /* Quick access buttons */
                              Stack(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.announcement),
                                    onPressed: () {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => Assignments(
                                          course: CoursesModel.activeCourses[index]
                                          )
                                        )
                                      );
                                    }
                                  ),
                                  FutureBuilder(
                                    future: CoursesModel.activeCourses[index].getAnnouncements(),
                                    builder: (context, snapshot) {
                                      /*
                                       * TODO: find proper empty widget that doesn't shift things around
                                       * when used
                                       */
                                      Widget empty = const Positioned(
                                        right: 0.0,
                                        top: 0.0,
                                        child: Text(""),
                                      );
                                      if (!snapshot.hasData) {
                                        return empty;
                                      }

                                      int unreadCount = 0;

                                      /* Count unread announcements */
                                      for (Announcement announcement in snapshot.data!) {
                                        if (!announcement.read) {
                                          ++unreadCount;
                                        }
                                      }

                                      if (unreadCount == 0) {
                                        return empty;
                                      }

                                      return Positioned(
                                        right: 0.0,
                                        top: 0.0,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.red
                                          ),
                                          padding: const EdgeInsets.all(4.0),
                                          child: Text("${unreadCount}"),
                                        )
                                      );
                                    }
                                  ),
                                ]
                              ),
                              IconButton(
                                icon: const Icon(Icons.assignment),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Assignments(
                                      course: CoursesModel.activeCourses[index]
                                      )
                                    )
                                  );
                                }
                              ),
                            ]),
                            const SizedBox(width: 8.0)
                          ],
                        )),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CourseScreen(index: index, all_courses: false,)));
                    },
                  )),
            );
          },
        ));
  }
}
