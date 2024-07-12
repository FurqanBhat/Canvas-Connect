import 'package:canvas_connect/models/CoursesModel.dart';
import 'package:canvas_connect/screen/file_viewer.dart';
import 'package:canvas_connect/shared/loading.dart';
import 'package:flutter/material.dart';

class FileScreen extends StatelessWidget {
  Course course;
  FileScreen({Key? key, required this.course}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Files',
      theme: ThemeData(
        primaryColor: Colors.blueAccent,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white, // Text color of app bar
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FilesViewer(id: file.fileId, fileVerifier: file.fileVerifier, fileName: file.name)));
                    },
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

