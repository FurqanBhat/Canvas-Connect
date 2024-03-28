import 'package:canvas_connect/screen/help.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _domainController;
  late TextEditingController _tokenController;
  GlobalKey<FormState> _formKey= GlobalKey();
  @override
  void initState() {
    super.initState();
    _domainController=TextEditingController();
    _tokenController=TextEditingController();
  }
  @override
  void dispose() {
    _domainController.dispose();
    _tokenController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              const SizedBox(height: 20,),
              Text(
                "Canvas Login",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: _domainController,
                decoration: InputDecoration(
                  filled: true,
                  labelText: 'Domain name',
                  hintText: 'eg. www.agu.edu.tr',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              TextFormField(
                controller: _tokenController,
                decoration: InputDecoration(
                  filled: true,
                  hintText: "e.g OWdLx3EdqeGg1YDUWtsUmQE0rYh6i8jdQwXNHKAMdFN1eGBOek6RWaP4uaaIsKp4",
                  labelText: 'Token',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black
                  ),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width*0.4,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Text('Help', style: TextStyle(color: Colors.white, fontSize: 22),),
                ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Help()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
