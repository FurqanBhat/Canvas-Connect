import 'package:canvas_connect/models/conservations_model.dart';
import 'package:flutter/material.dart';

import '../shared/loading.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool showSearchItems=false;
  late TextEditingController _controller;
  @override
  void initState() {
    super.initState();
    _controller=TextEditingController();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: TextFormField(
            controller: _controller,
            decoration: const InputDecoration(
              icon: Icon(Icons.search,
              // labelText: "Search for material",
              // labelStyle: TextStyle(color: r),
            ),
            // style: const TextStyle(
            //   color: foreGroundColor,
            ),
            onChanged: (String){
              setState(() {
                showSearchItems=true;
              });
            },

          ),
        ),
        body: showSearchItems ? FutureBuilder(
          future: ConversationsModel.searchUser(_controller.text),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
              return const Loading();
            }
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index){
                return ListTile(
                    title: Text(snapshot.data![index]['full_name'],
                      style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                    // const TextStyle(color: foreGroundColor, fontWeight: FontWeight.bold),),
                    onTap: () {}
                );
              },
            );

          },
        ):
            Container(
              padding: EdgeInsets.all(20),
              child: Text(
                "Search results will appear here",
                style: TextStyle(fontSize: 24,),
              ),
            )
      ),
    );
  }
}