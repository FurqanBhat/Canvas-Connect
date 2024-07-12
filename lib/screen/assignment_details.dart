import 'package:canvas_connect/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/LoginModel.dart';

class AssignmentDetail extends StatefulWidget {
  final int courseId;
  final int assignmentId;

  AssignmentDetail({required this.courseId, required this.assignmentId});

  @override
  _AssignmentDetailState createState() => _AssignmentDetailState();
}

class _AssignmentDetailState extends State<AssignmentDetail> {
  final TextEditingController _textController = TextEditingController();
  PlatformFile? _pickedFile;
  bool isLoading=false;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _pickedFile = result.files.first;
        print("file picked");
      });
    }
  }

  Future<void> _submitAssignment() async {
    final textComment = _textController.text;
    setState(() {
      isLoading=true;
    });

    if (_pickedFile != null) {
      // Implement file upload logic
      final fileUrl = await _uploadFile();
      final url =
          'https://${LoginModel.domain}/api/v1/courses/${widget.courseId}/assignments/${widget.assignmentId}/submissions?submission[submission_type]=online_upload&submission[file_ids][]=$fileUrl&access_token=${LoginModel.token}';
      print(url);
      final response = await http.post(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode <300 && response.statusCode>=200) {
        print("successful " + response.body.toString());
        // Show Snackbar on success
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Assignment submitted successfully!')),
        );
        // Clear text fields and file picker
        setState(() {
          _textController.clear();
          isLoading=false;
          _pickedFile = null;
        });
      } else {
        print("picked but not submitted");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit the assignment')),
        );
      }
    } else {
      print("picked file null");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No file picked')),
      );
    }
  }

  Future<int> _uploadFile() async {
    final createUploadUrl =
        'https://${LoginModel.domain}/api/v1/courses/${widget.courseId}/assignments/${widget.assignmentId}/submissions/self/files?name=${_pickedFile?.path?.split('/').last}&access_token=${LoginModel.token}';

    try {
      final response = await http.post(Uri.parse(createUploadUrl));
      print(response.statusCode);
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final String uploadUrl = responseData['upload_url'];
        final uploadParams = responseData['upload_params'];
        final request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
          ..fields['key'] = uploadParams['key']
          ..fields['acl'] = uploadParams['acl']
          ..fields['Filename'] = uploadParams['Filename']
          ..fields['Policy'] = uploadParams['Policy']
          ..fields['Signature'] = uploadParams['Signature']
          ..files.add(await http.MultipartFile.fromPath(
            'file',
            _pickedFile!.path!,
          ));

        final response2 = await request.send();
        print('response2 status code: ' + response2.statusCode.toString());
        if (response2.statusCode == 201) {
          // File successfully uploaded
          return uploadParams['key']; // Return the file path or ID
        } else {
          if (response2.statusCode < 400 && response2.statusCode >= 300) {
            print('in 302');
            final location = response2.headers['location'];
            if (location != null) {
              final finalResponse = await http.post(
                Uri.parse(location),
                headers: {
                  'Authorization': 'Bearer ${LoginModel.token}',
                },
              );
              print('Final response status code: ' + finalResponse.statusCode.toString());
              if (finalResponse.statusCode == 200) {
                final responseJson = jsonDecode(finalResponse.body);
                print("success uploading full method returning url");
                return responseJson["id"]; // Return the file URL or other relevant data
              } else {
                throw Exception('Failed to complete upload with 3XX response');
              }
            }
          } else {
            throw Exception('File upload failed');
          }
        }
      } else {
        throw Exception('Failed to get upload URL');
      }
    } catch (e) {
      print(e.toString());
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Loading() : Scaffold(
      appBar: AppBar(
        title: Text('Assignment Detail'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Text Comment',
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickFile,
              child: Text('Pick File'),
            ),
            _pickedFile != null
                ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                'Picked File: ${_pickedFile!.name}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            )
                : Container(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _submitAssignment,
                child: Text('Submit Assignment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
