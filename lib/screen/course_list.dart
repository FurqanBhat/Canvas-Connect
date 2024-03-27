import 'package:canvas_connect/resource/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Course {
  String id;
  String name;
  Color color;

  Course(this.id, this.name, this.color);
}

/* Sample course list */
class CourseList extends StatelessWidget {
  final List<Course> courses = [
    Course("ENG101", "English I", Colors.yellow),
    Course("MATH152", "Calculus II", Colors.red),
    Course("COMP112", "Object-Oriented Programming", Colors.orange),
    Course("GLB207", "Responsible Consumption and Production", Colors.teal),
    Course("COMP202", "Software Engineering", Colors.blue),
    Course("MATH203", "Linear Algebra", Colors.purple)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)
              ),
              elevation: 4.0,
              color: Theme.of(context).cardColor,
              child: InkWell(
                child: SizedBox(
                  height: 64.0,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24.0,
                        child: Container(
                          color: courses[index].color,
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              courses[index].id,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w200
                              ),
                            ),
                            Text(
                              courses[index].name,
                              style: const TextStyle(
                                fontSize: 10.0,
                              )
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Row(
                        children: [
                          /* Sample quick access buttons */
                          IconButton(
                            icon: const Icon(Icons.file_present),
                            onPressed: () {}
                          ),
                          IconButton(
                            icon: const Icon(Icons.announcement),
                            onPressed: () {}
                          ),
                          IconButton(
                            icon: const Icon(Icons.check_box),
                            onPressed: () {}
                          ),
                        ]
                      ),
                      const SizedBox(width: 8.0)
                    ],
                  )
                ),
                onTap: () {},
              )
            ),
          );
        },
      )
    );
  }
}
