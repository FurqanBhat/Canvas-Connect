import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:canvas_connect/shared/service.dart';

class LoginModel {
  static String _token = "";
  static String get token => _token;
  static String _domain = "canvas.agu.edu.tr";
  static String get domain => _domain;
  static bool _loginSuccessful = false;
  static bool get loginSuccessful => _loginSuccessful;

  LoginModel() {
    _loadLoginData();
  }

  static loginstart() async {
    await _loadLoginData();

    /* Start notification service */
    notificationService.startService();
  }

  static _loadLoginData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    _token = preferences.getString("token") ?? "";
    _domain = preferences.getString("domain") ?? "";
    _loginSuccessful = preferences.getBool("loginSuccessful") ?? false;
  }

  static _saveDataInPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("token", _token);
    preferences.setString("domain", _domain);
    preferences.setBool("loginSuccessful", _loginSuccessful);
  }

  static void setData(String token, String domain) {
    _token = token;
    if (domain == "") {
      _domain = "canvas.agu.edu.tr";
    } else {
      _domain = domain;
    }

    _saveDataInPref();
  }

  static void setLoginSuccessful() {
    _loginSuccessful = true;
    _saveDataInPref();
  }

  static void logOut() {
    print("logout");
    _token = "";
    _domain = "";
    _loginSuccessful = false;
    _saveDataInPref();
  }
}
