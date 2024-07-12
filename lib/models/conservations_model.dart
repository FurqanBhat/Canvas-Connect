import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'LoginModel.dart';

class ConversationsModel{
  static Future<void> addMessage(int id, String message) async{
    final response= await post(Uri.parse("https://${LoginModel.domain}/api/v1/conversations/${id}/add_message?body=${message}&access_token=${LoginModel.token}"));
    if(response.statusCode==200){
      print("success");
    };
  }

  static Future<dynamic> getSingleConversation(int id) async{
    List<dynamic> conversation1=[];
    List<dynamic> conversation2=[];
    final response1= await get(Uri.parse("https://${LoginModel.domain}/api/v1/conversations?scope=inbox&filter=user_${id}&filter_mode=or&per_page=50&access_token=${LoginModel.token}"));
    final response2= await get(Uri.parse("https://${LoginModel.domain}/api/v1/conversations?scope=sent&filter=user_${id}&filter_mode=or&per_page=50&access_token=${LoginModel.token}"));
    if(response1.statusCode==200 && response2.statusCode==200){
      try{
        conversation1=jsonDecode(response1.body);
        conversation2=jsonDecode(response2.body);
        conversation1.addAll(conversation2);
      }
      catch(e){
        print(e.toString());
      }
    }else{
      print("Error in getsingleconversations : error code: "+response1.statusCode.toString());
    }
    return conversation2;
  }

  static Future<List<dynamic>> getConversations(bool isSent) async{
    List<dynamic> conversations=[];
    final response= isSent ? await get(Uri.parse("https://${LoginModel.domain}/api/v1/conversations?scope=sent&filter_mode=or&per_page=50&access_token=${LoginModel.token}"))  :  await get(Uri.parse("https://canvas.agu.edu.tr/api/v1/conversations?scope=inbox&filter_mode=or&per_page=50&access_token=${LoginModel.token}"));
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
    final response=await get(Uri.parse("https://${LoginModel.domain}/api/v1/conversations/$id?per_page=50&access_token=${LoginModel.token}"));
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
    final response= await get(Uri.parse("https://${LoginModel.domain}/api/v1/search/recipients?search=${user}&per_page=50&access_token=${LoginModel.token}"));
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
    final response= await post(Uri.parse("https://${LoginModel.domain}/api/v1/conversations?recipients[]=${userId}&subject=${subject}&body=${body}&force_new=true&access_token=${LoginModel.token}"));
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