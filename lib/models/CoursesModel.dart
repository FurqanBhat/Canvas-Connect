import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'LoginModel.dart';
class CoursesModel{
  static bool requestSuccess=false;
  static Map<String, String> coursesName={};
  static List<dynamic> courses=[];
  static List<dynamic> allCourses=[];
  static Future<void> fetchCourses() async{
    final response= await get(Uri.parse("https://${LoginModel.domain}/api/v1/courses?per_page=50&access_token=${LoginModel.token}"));
    if(response.statusCode==200){
      requestSuccess=true;
      try{
        courses=jsonDecode(response.body);
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
    List temp=[];
    temp.addAll(courses);
    for(final course in courses){
      allCourses.add(course);
      String date_created=course["start_at"];
      int yearCreated=int.parse(date_created.substring(0,4));
      int monthCreated=int.parse(date_created.substring(5,7));
      if(currYear==yearCreated && (currMonth-monthCreated)>5){
        temp.remove(course);
      }else if((currYear-yearCreated)==1 &&  (monthCreated-currMonth)<7){
        temp.remove(course);
      }else if((currYear-yearCreated)>1){
        temp.remove(course);
      }
    }
    courses=temp;
  }
  static void setCoursesName(){
    for(final course in courses){
      coursesName["course_${course["id"]}"]=course["name"];
    }
  }
}