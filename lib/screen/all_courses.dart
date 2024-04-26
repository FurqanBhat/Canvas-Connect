import 'package:flutter/material.dart';
import 'package:canvas_connect/models/CoursesModel.dart';
import 'package:canvas_connect/screen/course_screen.dart';
class AllCourses extends StatelessWidget {
  const AllCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("All Courses"),
          leading: IconButton(icon: Icon(Icons.arrow_back,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: CoursesModel.allCourses.length,
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
                                color: CoursesModel.allCourses[index].color,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    CoursesModel.allCourses[index].code,
                                    style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w200),
                                  ),
                                  Text(CoursesModel.allCourses[index].name,
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
                                  onPressed: () {}),
                              IconButton(
                                  icon: const Icon(Icons.check_box),
                                  onPressed: () {}),
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
        ),
      ),
    );
  }
}