import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginModel{
  static String _token="";
  static String get token => _token;
  static String _domain="canvas.agu.edu.tr";
  static String get domain => _domain;
  static bool _loginSuccessful=false;
  static bool get loginSuccessful=> _loginSuccessful;
  static SharedPreferences? preferences;
  LoginModel(){
    _loadLoginData();
  }

  static  loginstart() async{
    await _loadLoginData();
  }

  static _initializePref() async {
    if(preferences==null){
      preferences= await SharedPreferences.getInstance();
    }
  }
  static _loadLoginData() async{
    await _initializePref();
    _token=preferences?.getString("token") ?? "";
    _domain=preferences?.getString("domain")?? "";
    _loginSuccessful=preferences?.getBool("loginSuccessful") ?? false;
  }

  static _saveDataInPref(){
    preferences?.setString("token", _token);
    preferences?.setString("domain", _domain);
    preferences?.setBool("loginSuccessful", _loginSuccessful);
  }
  static void setData(String token, String domain){
    _token=token;
    _domain=domain;
    _saveDataInPref();
  }
  static void setLoginSuccessful(){
    _loginSuccessful=true;
    _saveDataInPref();
  }
  static void logOut(){
    _token="";
    _domain="";
    _loginSuccessful=false;
    _saveDataInPref();
  }

}