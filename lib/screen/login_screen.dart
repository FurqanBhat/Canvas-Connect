import 'package:canvas_connect/models/CoursesModel.dart';
import 'package:canvas_connect/models/LoginModel.dart';
import 'package:canvas_connect/screen/course_list.dart';
import 'package:canvas_connect/screen/help.dart';
import 'package:canvas_connect/shared/loading.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _domainController;
  late TextEditingController _tokenController;
  bool _loading=false;
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

  @override
  Widget build(BuildContext context) {
    final snackBar=SnackBar(
      content: Text("Invalid Token.", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),),
      backgroundColor: Colors.blueGrey[900],
      padding: EdgeInsets.all(10),
      showCloseIcon: true,
      closeIconColor: Colors.white,
      action: SnackBarAction(
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        label: "Help",
        onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Help()));
        },

      ),
    );
    return _loading ? Loading() : Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.login,
                size: 50,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Canvas Login",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _domainController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Domain name',
                  hintText: 'eg. canvas.agu.edu.tr',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _tokenController,
                decoration: InputDecoration(
                  filled: true,
                  hintText:
                      "e.g OWdLx3EdqeGg1YDUWtsUmQE0rYh6i8jdQwXNHKAMdFN1eGBOek6RWaP4uaaIsKp4",
                  labelText: 'Token',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.4,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 26),
                  ),
                ),
                onTap: () async {
                  LoginModel.setData(_tokenController.text, _domainController.text);
                  print("after hello");
                  setState(() {
                    _loading=true;
                  });
                  try{
                    await CoursesModel.fetchCourses();
                    if(CoursesModel.requestSuccess){
                      LoginModel.setLoginSuccessful();
                      await LoginModel.loginstart();
                      setState(() {
                        _loading=false;
                      });
                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CourseList()));
                    }else{
                      setState(() {
                        _loading=false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }catch(e){
                    setState(() {
                      _loading=false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }



                },
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.3,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Text(
                    'Help',
                    style: TextStyle(color: Colors.white, fontSize: 22)
                  ),
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Help()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
