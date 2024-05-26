import 'package:canvas_connect/models/CoursesModel.dart';
import 'package:canvas_connect/models/LoginModel.dart';
import 'package:canvas_connect/screen/course_list.dart';
import 'package:canvas_connect/screen/help.dart';
import 'package:canvas_connect/shared/database_manager.dart';
import 'package:canvas_connect/shared/loading.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _domainController;
  late TextEditingController _tokenController;
  late TextEditingController _databaseDomainController;
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _domainController = TextEditingController();
    _tokenController = TextEditingController();
    _databaseDomainController = TextEditingController();
  }

  @override
  void dispose() {
    _domainController.dispose();
    _tokenController.dispose();
    _databaseDomainController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    /* Dismiss on-screen keyboard */
    FocusManager.instance.primaryFocus?.unfocus();

    setState(() {
      _loading = true;
    });

    try {
      LoginModel.setData(_tokenController.text, _domainController.text, _databaseDomainController.text);
      await CoursesModel.fetchCourses();

      if (!CoursesModel.requestSuccess) {
        _showSnackBar("Invalid token");
        throw Exception();
      }

      try {
        if (!await DatabaseManager.connect(LoginModel.databaseUri)) {
          throw Exception();
        }
      } on FormatException {
        _showSnackBar("Invalid database domain");
        throw Exception();
      } on Exception {
        _showSnackBar("Failed to connect to database. Extra features will be unavailable");
      }

      LoginModel.setLoginSuccessful();
      await LoginModel.loginstart();
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => CourseList()));
      } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 16, color: Colors.white),
      ),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Canvas-Connect",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF333333),
                    ),
                  ),
                  SizedBox(height: 20),
                  Icon(
                    Icons.login,
                    size: 70,
                  ),
                  SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _domainController,
                          style: TextStyle(color: Color(0xFF333333)),
                          decoration: InputDecoration(
                            labelText: 'Domain Name',
                            labelStyle: TextStyle(color: Color(0xFF333333)),
                            hintText: 'e.g. canvas.agu.edu.tr',
                            hintStyle: TextStyle(color: Color(0xFF666666)),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon:
                                Icon(Icons.domain, color: Color(0xFF333333)),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _tokenController,
                          style: TextStyle(color: Color(0xFF333333)),
                          decoration: InputDecoration(
                            labelText: 'Token',
                            labelStyle: TextStyle(color: Color(0xFF333333)),
                            hintText: 'Enter your token',
                            hintStyle: TextStyle(color: Color(0xFF666666)),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon:
                                Icon(Icons.vpn_key, color: Color(0xFF333333)),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _databaseDomainController,
                          style: TextStyle(color: Color(0xFF333333)),
                          decoration: InputDecoration(
                            labelText: 'Database Domain',
                            labelStyle: TextStyle(color: Color(0xFF333333)),
                            hintText: 'e.g. 127.0.0.1',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon:
                                Icon(Icons.storage, color: Color(0xFF333333)),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _handleLogin,
                          child: Text('Connect'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            padding:
                                MaterialStateProperty.all<EdgeInsetsGeometry>(
                                    EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 30)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Help()));
                          },
                          child: Text(
                            'Need Help?',
                            style: TextStyle(color: Color(0xFF008CFF)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_loading) Loading(),
        ],
      ),
    );
  }
}
