
import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey[800],
          foregroundColor: Colors.white,
          title: Text('Help', style: TextStyle(color: Colors.white),),
        ),
        body: Container(
          color: Colors.blueGrey[700],
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text("Log into your canvas account and click on the top left icon: 'Account'.", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),),
                SizedBox(height: 10,),
                Image.asset('assets/first.png'),
                SizedBox(height: 30,),
                Text("Click on 'Settings'.", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 20),),
                SizedBox(height: 10,),
                Image.asset('assets/second.png'),
                SizedBox(height: 30,),
                Text("Scroll down and click on 'New Access Token'.", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 20),),
                SizedBox(height: 10,),
                Image.asset('assets/third.png'),
                SizedBox(height: 30,),
                Text("In the 'Purpose' field, write whatever you want. It's does not matter. Leave the 'Expires' field blank because you don't want your token to expire.", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 20),),
                SizedBox(height: 10,),
                Image.asset('assets/fourth.png'),
                SizedBox(height: 30,),
                Text("You'll get a token like below. Copy it and paste it in the app to login. You won't be asked to login again.", style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500, fontSize: 20),),
                SizedBox(height: 10,),
                Image.asset('assets/fifth.png'),
                SizedBox(height: 30,),
                Divider(color: Colors.black, thickness: 5,),
                SizedBox(height: 10,),
                Text("Note: \nYour data is stored locally on your device, ensuring privacy. \nThe app solely relies on the Canvas LMS API, guaranteeing data security. Skip the database domain part as of now.", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16, color: Colors.greenAccent),),
                SizedBox(height: 20,)
              ],

            ),
          ),
        )
    );
  }

}