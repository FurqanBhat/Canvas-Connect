import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'LoginModel.dart';

class ConversationsModel{
  static Future<dynamic> addMessage(int id, String message) async{
    List<dynamic> sent_message=[];
    final response= await post(Uri.parse("https://canvas.agu.edu.tr/api/v1/conversations/10803/add_message?body=${message}&access_token=${LoginModel.token}"));
    if(response.statusCode==200){
      try{
        sent_message=jsonDecode(response.body);
      }catch(e){
        print("eroor in addmessage "+e.toString());
      }
    }
    return sent_message;
  }

  static Future<dynamic> getSingleConversation(int id) async{
    List<dynamic> conversation=[];
    final response=await get(Uri.parse("https://canvas.agu.edu.tr/api/v1/conversations?scope=sent&scope=inbox&filter=user_${id}&filter_mode=or&per_page=50&access_token=${LoginModel.token}"));
    if(response.statusCode==200){
      try{
        conversation=jsonDecode(response.body);
      }
      catch(e){
        print(e.toString());
      }
    }else{
      print("Error in getsingleconversations : error code: "+response.statusCode.toString());
    }
    return conversation;
  }

  static Future<List<dynamic>> getConversations() async{
    List<dynamic> conversations=[];
    final response=await get(Uri.parse("https://canvas.agu.edu.tr/api/v1/conversations?scope=sent&scope=inbox&filter_mode=or&per_page=50&access_token=${LoginModel.token}"));
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
  static Future<dynamic> searchUser(String user) async{
    List<dynamic> users=[];
    final response= await get(Uri.parse("https://canvas.agu.edu.tr/api/v1/search/recipients?search=${user}&per_page=50&access_token=${LoginModel.token}"));
    if(response.statusCode==200){
      try{
        users=jsonDecode(response.body);
      }catch(e){
        print("error in searchusers "+ e.toString());
      }
    }
    return users;
  }
  static Future<List<dynamic>> createConversation(int userId, String subject, String body) async {
    List<dynamic> conversation=[];
    final response= await post(Uri.parse("https://canvas.agu.edu.tr/api/v1/conversations?recipients[]=${userId}&subject=${subject}&body=${body}&force_new=true&access_token=${LoginModel.token}"));
    if(response.statusCode==200){
      try{
        conversation=jsonDecode(response.body);
      }catch(e){
        print("eroor in createconversation "+e.toString());
      }
    }
    return conversation;
  }
}