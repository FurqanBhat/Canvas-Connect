import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'LoginModel.dart';

class Announcement {
  String title;
  String message;
  DateTime postedAt;

  Announcement(this.title, this.message, this.postedAt);
}
class Grade {
  String name;
  double score;
  double points_possible;
  Grade({required this.name, required this.score, required this.points_possible});
}
class Discussion{
  String title;
  String html_description;
  Discussion({required this.title, required this.html_description});
}

class Assignment {
  String name;
  String description;
  DateTime dueAt;

  Assignment(this.name, this.description, this.dueAt);
}
class File {
  String name;
  int fileId;
  String fileVerifier;
  File({required this.name, required this.fileId, required this.fileVerifier});
}

class Course {
  int id;
  String code;
  String name;
  Color color;

  Course({required this.id, required this.code, required this.name, required this.color});

  Future<List<Discussion>> getDiscussions() async{
    List<Discussion> discussions=[];
    final response=await get(Uri.parse('https://canvas.agu.edu.tr/api/v1/courses/${id}/discussion_topics?per_page=50&access_token=${LoginModel.token}'));
    if(response.statusCode==200){
      try{
        final discussionsData=jsonDecode(response.body);
        for(final discussion in discussionsData) {
          discussions.add(
              Discussion(title: discussion['title'],
                  html_description: discussion['message'])
          );
        }
      }catch(e){
        print(e.toString());
      }
    }else{
      print("error in results_model, error code: ${response.statusCode}");
    }
    return discussions;
  }

  /* getAnnouncements - Get announcements for course
   *
   * since: Date to get announcements created since. Only announcements created after
   *        this date will be returned.
   */
  Future<List<Announcement>> getAnnouncements({DateTime? since}) async {
    List<Announcement> announcements = [];
    try {
      final response = await get(Uri.parse(
        "https://${LoginModel.domain}/api/v1/announcements?context_codes[]=course_${id}&access_token=${LoginModel.token}${since != null ? "&start_date=${since.toIso8601String()}" : ""}"
      ));
      print("https://${LoginModel.domain}/api/v1/announcements?context_codes[]=course_${id}&access_token=${LoginModel.token}${since != null ? "&start_date=${since.toIso8601String()}" : ""}");
      final announcementData = jsonDecode(response.body);

      for (final announcement in announcementData) {
        announcements.add(
            Announcement(
                announcement["title"],
                announcement["message"],
                DateTime.parse(announcement["posted_at"])
            )
        );
      }
    } catch (e) {
      print("Failed to get announcements: "+ e.toString());
    }

    return announcements;
  }
  Future<List<File>> fetchFiles({DateTime? since}) async{
    List<File> files=[];
    final response=await get(Uri.parse('https://canvas.agu.edu.tr/api/v1/courses/${id}/files?per_page=50&sort=created_at&access_token=${LoginModel.token}'));
    if(response.statusCode==200){
      try{
        final filesData=jsonDecode(response.body);
        for(final file in filesData){
          files.add(
              File(
                  name: file['display_name'],
                  fileId: file['id'],
                  fileVerifier: file['uuid']
              )
          );

        }
      }
      catch (e){
        print(e.toString());
      }
    }
    else{
      print("Errror in flies_model : ${response.statusCode}");
    }
    return files;
  }

  /* getAssignments - Get assignments for course
   *
   * since: Date to get assignments created since. Only assignments created after
   *        this date will be returned.
   */
  Future<List<Assignment>> getAssignments({DateTime? since}) async {
    List<Assignment> assignments = [];
    try {
      final response = await get(Uri.parse("https://${LoginModel.domain}/api/v1/courses/${id}/assignments?access_token=${LoginModel.token}"));
      final assignmentData = jsonDecode(response.body);

      for (final assignment in assignmentData) {
        /* Skip old assignments if since date is provided */
        if (since != null && DateTime.parse(assignment["created_at"]).isBefore(since)) {
          continue;
        }
        assignments.add(
            Assignment(
                assignment["name"],
                assignment["description"],
                DateTime.parse(assignment["due_at"])
            )
        );
      }
    } catch (e) {
      print("Failed to get assignments: "+ e.toString());
    }

    return assignments;
  }
  Future<List<Grade>> getGrades() async{
    List<Grade> grades=[];
    final response=await get(Uri.parse('https://canvas.agu.edu.tr/api/v1/courses/${id}/students/submissions?per_page=50&order=graded_at&order_direction=descending&include[]=assignment&include[]=total_scores&access_token=${LoginModel.token}'));
    if(response.statusCode==200){
      try{
        final GradesData=jsonDecode(response.body);
        for(final grade in GradesData){
          grades.add(
              Grade(
                  name: grade["assignment"]["name"],
                  score: grade["assignment"]["score"] ?? 0,
                  points_possible: grade['assignment']['points_possible'] ?? 100
              )
          );
        }
      }catch(e){
        print(e.toString());
      }
    }else{
      print("error in results_model, error code: ${response.statusCode}");
    }
    return grades;
  }
}


class CoursesModel{
  static bool requestSuccess=false;
  static Map<String, String> coursesName={};
  static Map<String, String> allcoursesName={};
  static List<dynamic> courseData=[];
  static List<dynamic> allCourseData=[];

  static List<Course> activeCourses = [];
  static List<Course> allCourses=[];


  static Future<void> fetchCourses() async{
    final response= await get(Uri.parse("https://${LoginModel.domain}/api/v1/courses?per_page=50&access_token=${LoginModel.token}"));
    if(response.statusCode==200){
      requestSuccess=true;
      try{
        courseData=jsonDecode(response.body);
        setCourses();
        setCoursesName();
      }
      catch(e){
        print(e.toString() +"my error");
      }

    }else{
      requestSuccess=false;
      print(response.statusCode);
    }

  }

  static void setCourses() {
    DateTime now=DateTime.now();
    print(now);
    int currMonth=now.month;
    int currYear=now.year;

    /* Remove any courses left from previous logins */
    activeCourses = [];

    List temp=[];
    temp.addAll(activeCourses);
    for(final course in courseData){
      allCourseData.add(course);
      String date_created=course["start_at"];
      int yearCreated=int.parse(date_created.substring(0,4));
      int monthCreated=int.parse(date_created.substring(5,7));
      if(currYear==yearCreated && (currMonth-monthCreated)>5){
        temp.remove(course);
      }else if((currYear-yearCreated)==1 &&  (monthCreated-currMonth)<7){
        temp.remove(course);
      }else if((currYear-yearCreated)>1){
        temp.remove(course);
      } else {
        activeCourses.add(
            Course (
                id: course["id"],
                code: course["course_code"],
                name: course["name"],
                /* TODO: Get user-defined color from Canvas when available */
                color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
            )
        );
      }
      allCourses.add(
            Course (
                id: course["id"],
                code: course["course_code"],
                name: course["name"],
                /* TODO: Get user-defined color from Canvas when available */
                color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
            )
        );
    }
    courseData=temp;
  }
  static void setCoursesName(){
    for(final course in courseData){
      coursesName["course_${course["id"]}"]=course["name"];
    }
    for(final course in allCourseData){
      coursesName["course_${course["id"]}"]=course["name"];
    }

  }
}