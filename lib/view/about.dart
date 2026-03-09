import 'package:app/view/common/form_row.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
      ),
      body: ListView(
        padding: EdgeInsets.all(2),
        children: [
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, ss) => FormSection(children: [
              FormRow(
                title: Text('App Name'),
                trailing: Text(ss.data?.appName ?? ''),
              ),
              FormRow(
                title: Text('Version'),
                trailing: Text(ss.data?.version ?? ''),
              ),
              FormRow(
                title: Text('Build Number'),
                trailing: Text(ss.data?.buildNumber ?? ''),
              ),
            ]),
          ),
          FormSection(children: [
            FormRow(
              title: Text('Privacy Policy'),
              trailing: Icon(Icons.open_in_new),
            onTap: () => launchUrl(Uri.parse('https://nfcmanager.naokiokada.com/privacy-policy/')),
            ),
          ]),
        ],
      ),
    );
  }
}
