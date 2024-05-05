import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'LoginModel.dart';

class ConversationsModel{
  static Future<List<dynamic>> getConversations() async{
    List<dynamic> conversations=[];
    final response=await get(Uri.parse("https://canvas.agu.edu.tr/api/v1/conversations?per_page=50&access_token=${LoginModel.token}"));
    if(response.statusCode==200){
      try{
        conversations=jsonDecode(response.body);
      }
      catch(e){
        print(e.toString());
      }
    }else{
      print("Error in conversations.dart : error code: "+response.statusCode.toString());
    }
    return conversations;
  }
  static Future<dynamic> getFullMessage(int id) async{
    dynamic fullMessage;
    final response=await get(Uri.parse("https://canvas.agu.edu.tr/api/v1/conversations/$id?per_page=50&access_token=${LoginModel.token}"));
    if(response.statusCode==200){
      try{
        fullMessage=jsonDecode(response.body);
      }
      catch(e){
        print(e.toString());
      }
    }else{
      print("Error in conversations.dart : error code: "+response.statusCode.toString());
    }
    return fullMessage;


  }
}