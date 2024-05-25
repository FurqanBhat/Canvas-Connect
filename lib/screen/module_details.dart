import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/CoursesModel.dart';

class ModuleDetailsPage extends StatelessWidget {
  final Course course;

  final int id;
  const ModuleDetailsPage({super.key, required this.course, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Module Items'),
      ),
      body: FutureBuilder<List<ModuleItem>>(
        future:course.getModulesDetails(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text('Type: ${item.type}'),
                  leading: Icon(_getIconForType(item.type)),
                  onTap: () {
                    if (item.type == 'File' && item.url != null) {
                      _launchURL(item.url!);
                    } else if (item.type == 'ExternalUrl' && item.externalUrl != null) {
                      _launchURL(item.externalUrl!);
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'SubHeader':
        return Icons.headphones;
      case 'File':
        return Icons.insert_drive_file;
      case 'ExternalUrl':
        return Icons.link;
      default:
        return Icons.help_outline;
    }
  }

  void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}