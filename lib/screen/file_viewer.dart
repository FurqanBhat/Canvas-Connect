import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';

class FilesViewer extends StatefulWidget {
  final int id;
  final String fileVerifier, fileName;

  FilesViewer({super.key, required this.id, required this.fileVerifier, required this.fileName});

  @override
  State<FilesViewer> createState() => _FilesViewerState();
}

class _FilesViewerState extends State<FilesViewer> {
  String? pdfFilePath;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  @override
  void dispose() {
    if (pdfFilePath != null) {
      File(pdfFilePath!).delete();
    }
    super.dispose();
  }

  Future<String?> downloadAndSavePDF() async {
    String url = "https://canvas.agu.edu.tr/files/${widget.id}/download?download_frd=1&verifier=${widget.fileVerifier}";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/${widget.fileName}';
      File file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      throw Exception('Failed to download PDF');
    }
  }

  void loadPdf() async {
    pdfFilePath = await downloadAndSavePDF();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.fileName),
      ),
      body: SafeArea(
        child: (pdfFilePath != null)
            ? PdfViewer(filePath: pdfFilePath!, fileName: widget.fileName, url: "https://canvas.agu.edu.tr/files/${widget.id}/download?download_frd=1&verifier=${widget.fileVerifier}")
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

class PdfViewer extends StatelessWidget {
  final String filePath;
  final String fileName;
  final String url;

  PdfViewer({required this.filePath, required this.fileName, required this.url});

  Future<void> downloadFile(BuildContext context) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        print('File saved to $filePath');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download complete'),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () {
                _openFile(filePath);
              },
            ),
          ),
        );
      } else {
        print('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _openFile(String filePath) async {
    final result = await OpenFile.open(filePath);
    print(result.message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: _buildFileViewer(filePath, context),
      ),
    );
  }

  Widget _buildFileViewer(String filePath, BuildContext context) {
    if (filePath.endsWith('.pdf')) {
      return PdfView(path: filePath);
    } else if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg') || filePath.endsWith('.png')) {
      return Image.file(File(filePath));
    } else {
      return Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              Text(
                'Unsupported file type,',
                style: TextStyle(color: Colors.red[300], fontSize: 16),
              ),
              TextButton(
                child: Text("Download File"),
                onPressed: () {
                  downloadFile(context);
                },
              )
            ],
          ),
        ),
      );
    }
  }
}
