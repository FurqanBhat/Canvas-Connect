import 'package:flutter/material.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({Key? key}) : super(key: key);

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  int _selectedIndex = 0;
  final List<String> _announcements = [
    "Announcement 1",
    "Announcement 2",
    "Announcement 3",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          "MATH154",
          style: TextStyle(
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
            _buildSectionTitle("Announcements"),
            const SizedBox(height: 12.0),
            _buildAnnouncementsList(),
            _buildViewAllButton(onPressed: () {
              // Route to announcements
            }),
            const SizedBox(height: 16.0),
            _buildSectionTitle("Assignments"),
            const SizedBox(height: 12.0),
            _buildAssignmentsCalendar(),
            const SizedBox(height: 16.0),
            _buildMaterialSectionTitle("Course Materials"),
            const SizedBox(height: 12.0),
            _buildMaterialLinks(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blueGrey,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildMaterialSectionTitle(String title) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Colors.blueGrey,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildViewAllButton({required VoidCallback onPressed}) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        "View all",
        style: TextStyle(
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildAnnouncementsList() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      height: 200,
      child: PageView.builder(
        itemCount: _announcements.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  _announcements[index],
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAssignmentsCalendar() {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Column(
        children: [
          _buildAssignmentCard(
            title: "Assignment 1",
            dueDate: "2024-04-15",
          ),
          Divider(),
          _buildAssignmentCard(
            title: "Assignment 2",
            dueDate: "2024-04-20",
          ),
          Divider(),
          _buildAssignmentCard(
            title: "Assignment 3",
            dueDate: "2024-04-25",
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(
      {required String title, required String dueDate}) {
    return Card(
      elevation: 0.0, // Set elevation to 0 to remove hovering effect
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
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Due: $dueDate",
                    style: TextStyle(
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
          icon: Icon(Icons.assignment),
          title: "Syllabus",
          onTap: () {
            // Navigate to syllabus page
          },
        ),
        _buildMaterialLink(
          icon: Icon(Icons.folder),
          title: "Files",
          onTap: () {
            // Navigate to files page
          },
        ),
        _buildMaterialLink(
          icon: Icon(Icons.chat),
          title: "Discussion",
          onTap: () {
            // Navigate to discussion page
          },
        ),
        _buildMaterialLink(
          icon: Icon(Icons.grade),
          title: "Grades",
          onTap: () {
            // Navigate to grades page
          },
        ),
        _buildMaterialLink(
          icon: Icon(Icons.people),
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
        style: TextStyle(
          fontSize: 16,
          color: Colors.blueGrey,
        ),
      ),
      onTap: onTap,
    );
  }
}
