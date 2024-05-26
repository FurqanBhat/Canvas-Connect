import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:canvas_connect/shared/service.dart';

const databasePort = 3307; // canvas-connect-server port

class LoginModel {
  static String _token = "";
  static String get token => _token;
  static String _domain = "canvas.agu.edu.tr";
  static String get domain => _domain;
  static late Uri _databaseUri;
  static Uri get databaseUri => _databaseUri;
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

    String? databaseDomain = preferences.getString("databaseDomain");

    _databaseUri = Uri.parse("http://$databaseDomain:$databasePort");

    _loginSuccessful = preferences.getBool("loginSuccessful") ?? false;
  }

  static _saveDataInPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString("token", _token);
    preferences.setString("domain", _domain);
    preferences.setString("databaseDomain", databaseUri.host);
    preferences.setBool("loginSuccessful", _loginSuccessful);
  }

  static void setData(String token, String domain, String databaseDomain) {
    _token = token;

    _databaseUri = Uri.parse("http://$databaseDomain");
    if (!_databaseUri.hasPort) {
      _databaseUri = Uri.parse("http://${databaseUri.host}:$databasePort");
    }

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
