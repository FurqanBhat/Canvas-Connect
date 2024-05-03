import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
class FilesViewer extends StatefulWidget {
  int id;
  String fileVerifier, fileName;
  FilesViewer({super.key, required this.id, required this.fileVerifier, required this.fileName});
  @override
  State<FilesViewer> createState() => _MyAppState();
}

class _MyAppState extends State<FilesViewer> {
  @override
  void initState() {
    super.initState();
    loadPdf();
  }
  @override
  void dispose(){
    try{
      File(pdfFlePath!).delete();
    }
    catch(e){
      print(e.toString());
    }

    super.dispose();

  }

  String? pdfFlePath;

  Future<String?> downloadAndSavePDF() async {
    String url = "https://canvas.agu.edu.tr/files/${widget.id}/download?download_frd=1&verifier=${widget.fileVerifier}";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory
          .path}/${widget.fileName}'; // Adjust the file name as needed
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      throw Exception('Failed to download PDF');
    }
  }

  void loadPdf() async {
    pdfFlePath = (await downloadAndSavePDF())!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: (pdfFlePath != null) ?
        Container(
          child: PdfViewer(filePath: pdfFlePath!, fileName: widget.fileName,),
        ) :
        Center(child: CircularProgressIndicator()),
      ),
    );
  }

}
class PdfViewer extends StatelessWidget {
  final String filePath;
  final String fileName;

  PdfViewer({required this.filePath, required this.fileName});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back_outlined),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            fileName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: _buildFileViewer(filePath),
        ),
      ),
    );
  }

  Widget _buildFileViewer(String filePath) {
    if (filePath.endsWith('.pdf')) {
      return PdfView(
        path: filePath,
      );
    }else if(filePath.endsWith('.jpg') || filePath.endsWith('.jpeg') || filePath.endsWith('.png')){
      return Image.file(File(filePath));
    }
    else {
      return  Center(
          child: Container(
              padding: EdgeInsets.all(10),
              child: Text('Unsupported file type, only pdf/jpg/jpeg/png formats are supported. You can ask your instructor to upload pdf files only.',
                style: TextStyle(color: Colors.red[300], fontSize: 16),
              )));
    }
  }
}