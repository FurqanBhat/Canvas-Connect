// import 'package:flutter/material.dart';
//
// // Define a placeholder RouteManager class for demonstration
// class RouteManager {
//   static const String pdfViewer = '/pdf_viewer';
// // Add other routes as needed
// }
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'My App',
//       theme: ThemeData(
//         primaryColor: Colors.blueAccent,
//         appBarTheme: AppBarTheme(
//           backgroundColor: Colors.blueAccent,
//           foregroundColor: Colors.white, // Text color of app bar
//         ),
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => FileScreen(),
//         RouteManager.pdfViewer: (context) => PdfViewerScreen(),
//         // Define other routes as needed
//       },
//     );
//   }
// }
//
// class FileScreen extends StatelessWidget {
//   const FileScreen({Key? key}) : super(key: key);
//
//   // Function to open PDF viewer
//   void openPDFViewer(BuildContext context, Map<String, dynamic> file) {
//     // Navigate to PDF viewer screen and pass file information
//     Navigator.of(context).pushNamed(
//       RouteManager.pdfViewer,
//       arguments: {
//         'id': file['id'],
//         'uuid': file['uuid'],
//         'display_name': file['display_name'],
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, dynamic>> filePdf = [
//       {"id": 569, "uuid": "SUj23659sdfASF35h265kf352YTdnC4", "display_name": "file1.txt"},
//       {"id": 432, "uuid": "SA23659sdfAhgjkh265kf352YTdnC4", "display_name": "file2.txt"},
//       {"id": 109, "uuid": "PbG23659sdfASF35h265kfjy2TdnC4", "display_name": "file3.txt"},
//     ];
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           "Files",
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         centerTitle: true,
//       ),
//       body: ListView.builder(
//         itemCount: filePdf.length,
//         itemBuilder: (context, index) {
//           final file = filePdf[index];
//           return InkWell(
//             onTap: () => openPDFViewer(context, file),
//             child: Card(
//               margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.file_copy,
//                       size: 32,
//                       color: Colors.blueAccent,
//                     ),
//                     SizedBox(width: 16),
//                     Expanded(
//                       child: Text(
//                         file['display_name'],
//                         style: TextStyle(fontSize: 18),
//                       ),
//                     ),
//                     Icon(
//                       Icons.error_outline, // Error icon
//                       color: Colors.red, // Error icon color
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class PdfViewerScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // Implement your PDF viewer screen here
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('PDF Viewer'),
//       ),
//       body: Center(
//         child: Text(
//           'PDF Viewer Screen',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
