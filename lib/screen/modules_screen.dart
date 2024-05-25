import 'package:canvas_connect/models/CoursesModel.dart';
import 'package:canvas_connect/screen/module_details.dart';
import 'package:flutter/material.dart';

import '../shared/loading.dart';
class ModulesListScreen extends StatelessWidget {
  final Course course;
  const ModulesListScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "Modules",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder(
          future: course.getModules(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Loading();
            }
            return ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Module module = snapshot.data![index];
                final title = module.name;
                final int id=module.id;
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: ListTile(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ModuleDetailsPage(course: course, id: id)));
                    },
                    contentPadding: EdgeInsets.all(15.0),
                    title: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                  ),
                );
              },
            );
          }),
    );
  }
}
