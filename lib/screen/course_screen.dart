import 'package:canvas_connect/screen/announcements.dart';
import 'package:canvas_connect/screen/assignments.dart';
import 'package:canvas_connect/screen/file.dart';
import 'package:canvas_connect/screen/grade.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:canvas_connect/models/CoursesModel.dart';
import 'package:canvas_connect/shared/loading.dart';
import 'package:canvas_connect/screen/conversations.dart';

class CourseScreen extends StatefulWidget {
  final int index;
  bool all_courses;

   CourseScreen({super.key, required this.index, required this.all_courses});

  @override
  CourseScreenState createState() => CourseScreenState();
}

class CourseScreenState extends State<CourseScreen> {
  late Course course = widget.all_courses? CoursesModel.allCourses[widget.index] : CoursesModel.activeCourses[widget.index];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Course course = widget.all_courses? CoursesModel.allCourses[widget.index] : CoursesModel.activeCourses[widget.index];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: course.color,
        foregroundColor: Colors.white,
        title: Text(
          course.code,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSectionTitle("Announcements", true, "Announcements"),
            const SizedBox(height: 8.0),
            _buildAnnouncementsList(),
            // _buildViewAllButton(onPressed: () {
            //   // Route to announcements
            // }),
            const SizedBox(height: 16.0),
            _buildSectionTitle("Assignments", true, 'Assignments'),
            const SizedBox(height: 8.0),
            _buildAssignmentsCalendar(),
            const SizedBox(height: 16.0),
            _buildSectionTitle("Course Materials", false, ''),
            const SizedBox(height: 8.0),
            _buildMaterialLinks(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: course.color,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'To Do',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: 'Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Grades',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildSectionTitle(String title, bool showIcon, String navigateTo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              // fontWeight: FontWeight.bold,
            ),
          ),
        ),
        showIcon
            ? IconButton(
                icon: Icon(Icons.open_in_new),
                onPressed: () {
                  switch (navigateTo) {
                    case "Assignments":
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Assignments(course: course)));
                      break;
                    case "Announcements":
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Announcements(course: course)));
                      break;
                    default:
                      () {};
                  }
                },
              )
            : Container(),
      ],
    );
  }

  /* TODO: Add separate announcement section */
  // Widget _buildViewAllButton({required VoidCallback onPressed}) {
  //   return TextButton(
  //     onPressed: onPressed,
  //     child: const Text(
  //       "View all",
  //       style: TextStyle(
  //         color: Colors.blueGrey,
  //       ),
  //     ),
  //   );
  // }

  Widget _buildAnnouncementsList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200.0),
      child: FutureBuilder(
          future: course.getAnnouncements(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Loading();
            }

            print(snapshot.data!);

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Announcement announcement = snapshot.data![index];

                return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            announcement.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            "Posted ${DateFormat.MMMd().format(announcement.postedAt)}, ${DateFormat.Hm().format(announcement.postedAt)}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ));
              },
            );
          }),
    );
  }

  Widget _buildAssignmentsCalendar() {
    return Container(
      child: FutureBuilder(
          future: course.getAssignments(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Loading();
            }

            print(snapshot.data!);

            return SizedBox(
              height: 300.0,
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Assignment assignment = snapshot.data![index];

                  return _buildAssignmentCard(
                    title: assignment.name,
                    dueDate:
                        "${DateFormat.MMMd().format(assignment.dueAt)}, ${DateFormat.Hm().format(assignment.dueAt)}",
                  );
                },
              ),
            );
          }),
    );
  }

  Widget _buildAssignmentCard(
      {required String title, required String dueDate}) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "Due $dueDate",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialLinks() {
    return Column(
      children: [
        _buildMaterialLink(
          icon: const Icon(Icons.assignment),
          title: "Syllabus",
          onTap: () {
            // Navigate to syllabus page
          },
        ),
        _buildMaterialLink(
          icon: const Icon(Icons.folder),
          title: "Files",
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => FileScreen(course: course)));
          },
        ),
        _buildMaterialLink(
          icon: const Icon(Icons.chat),
          title: "Discussion",
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Conversations(),
            ));
          },
        ),
        _buildMaterialLink(
          icon: const Icon(Icons.grade),
          title: "Grades",
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Grades(course: course)));
          },
        ),
        _buildMaterialLink(
          icon: const Icon(Icons.people),
          title: "Students",
          onTap: () {
            // Navigate to students page
          },
        ),
      ],
    );
  }

  Widget _buildMaterialLink({
    required Icon icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}
