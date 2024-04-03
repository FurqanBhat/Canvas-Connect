import 'package:canvas_connect/models/LoginModel.dart';
import 'package:canvas_connect/resource/theme.dart';
import 'package:canvas_connect/screen/course_screen.dart';
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
                  color: Theme.of(context).primaryColor
                ),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Canvas-Connect",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                )
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Log out"),
                onTap: () {
                  LoginModel.logOut();
                  Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
              )
            ],
          )
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: CoursesModel.courses.length,
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
                                color: CoursesModel.courses[index].color,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    CoursesModel.courses[index].code,
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w200),
                                  ),
                                  Text(CoursesModel.courses[index].name,
                                      style: const TextStyle(
                                        fontSize: 10.0,
                                      )),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Row(children: [
                              /* Quick access buttons */
                              IconButton(
                                  icon: const Icon(Icons.announcement),
                                  onPressed: () {}
                              ),
                              IconButton(
                                  icon: const Icon(Icons.check_box),
                                  onPressed: () {}
                              ),
                            ]),
                            const SizedBox(width: 8.0)
                          ],
                        )),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CourseScreen(index)));
                    },
                  )),
            );
          },
        ));
  }
}
