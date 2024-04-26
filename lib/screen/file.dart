import 'package:canvas_connect/models/CoursesModel.dart';
import 'package:canvas_connect/shared/loading.dart';
import 'package:flutter/material.dart';

class FileScreen extends StatelessWidget {
  Course course;
  FileScreen({Key? key, required this.course}) : super(key: key);

  // Function to open PDF viewer
  // void openPDFViewer(BuildContext context, Map<String, dynamic> file) {
  //   // Navigate to PDF viewer screen and pass file information
  //   Navigator.of(context).pushNamed(
  //     RouteManager.pdfViewer,
  //     arguments: {
  //       'id': file['id'],
  //       'uuid': file['uuid'],
  //       'display_name': file['display_name'],
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white, // Text color of app bar
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Files",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: course.fetchFiles(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Loading();
              }
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  File file = snapshot.data![index];
                  return InkWell(
                    onTap: () {},
                    child: Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.file_copy,
                              size: 32,
                              color: Colors.blueAccent,
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                file.name,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                            Icon(
                              Icons.error_outline, // Error icon
                              color: Colors.red, // Error icon color
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
      ),
    );
  }
}

// class PdfViewerScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Implement your PDF viewer screen here
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//       ),
//       body: Center(
//         child: Text(
//           'PDF Viewer Screen',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
