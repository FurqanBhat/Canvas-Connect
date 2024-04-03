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

class Assignment {
  String name;
  String description;
  DateTime dueAt;

  Assignment(this.name, this.description, this.dueAt);
}

class Course {
  int id;
  String code;
  String name;
  Color color;

  Course({required this.id, required this.code, required this.name, required this.color});

  Future<List<Announcement>> getAnnouncements() async {
    List<Announcement> announcements = [];
    try {
      final response = await get(Uri.parse("https://${LoginModel.domain}/api/v1/announcements?context_codes[]=course_${id}&access_token=${LoginModel.token}"));
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

  Future<List<Assignment>> getAssignments() async {
    List<Assignment> assignments = [];
    try {
      final response = await get(Uri.parse("https://${LoginModel.domain}/api/v1/courses/${id}/assignments?access_token=${LoginModel.token}"));
      final assignmentData = jsonDecode(response.body);

      for (final assignment in assignmentData) {
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
}

class CoursesModel{
  static bool requestSuccess=false;
  static Map<String, String> coursesName={};
  static List<dynamic> courseData=[];
  static List<dynamic> allCourseData=[];

  static List<Course> courses = [];

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
    courses = [];

    List temp=[];
    temp.addAll(courses);
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
        courses.add(
          Course (
            id: course["id"],
            code: course["course_code"],
            name: course["name"],
            /* TODO: Get user-defined color from Canvas when available */
            color: Colors.primaries[Random().nextInt(Colors.primaries.length)]
          )
        );
      }
    }
    courseData=temp;
  }
  static void setCoursesName(){
    for(final course in courseData){
      coursesName["course_${course["id"]}"]=course["name"];
    }
  }
}