import 'package:canvas_connect/models/CoursesModel.dart';
import 'package:canvas_connect/models/LoginModel.dart';
import 'package:canvas_connect/screen/course_list.dart';
import 'package:canvas_connect/screen/help.dart';
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
  bool _loading = false;
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _domainController = TextEditingController();
    _tokenController = TextEditingController();
  }

  @override
  void dispose() {
    _domainController.dispose();
    _tokenController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    setState(() {
      _loading = true;
    });

    try {
      LoginModel.setData(_tokenController.text, _domainController.text);
      await CoursesModel.fetchCourses();

      if (CoursesModel.requestSuccess) {
        LoginModel.setLoginSuccessful();
        await LoginModel.loginstart();
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CourseList()));
      } else {
        _showSnackBar("Invalid Token.");
      }
    } catch (e) {
      _showSnackBar("An error occurred.");
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
                  Text(
                    "Canvas-Connect",
                    style: TextStyle(
                      fontSize: 47,
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
                        ElevatedButton(
                          onPressed: _handleLogin,
                          child: Text('Connect'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xFF008CFF)),
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
