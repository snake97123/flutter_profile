import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(ProfileApp());
}

class ProfileApp extends StatelessWidget {
  ProfileApp({super.key});

  final String mailAdress = "flutter.database@gmail.com";
  final String mailTitle = "件名";
  final String mailContents = "内容";
  final String webSite = "https://twitter.com/";

  ScreenshotController screenshotController = ScreenshotController();

  Future<void> launchURL(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception("Could not launch ${url}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.green.shade100,
        appBar: AppBar(
          backgroundColor: Colors.green,
          actions: [
            TextButton(
                onPressed: () async {
                  await screenshotController
                      .capture(delay: const Duration(milliseconds: 10))
                      .then((image) async {
                    if (image != null) {
                      final directory =
                          (await getApplicationCacheDirectory()).path;
                      final imagePath =
                          await File('${directory}/image.png').create();
                      await imagePath.writeAsBytes(image);

                      await Share.shareXFiles([XFile(imagePath.path)],
                          text: '私のプロフィールです。');
                    }
                  });
                },
                child: Icon(Icons.share, color: Colors.white))
          ],
          title: const Text('My Profile'),
        ),
        body: Center(
          child: Column(
            children: [
              Screenshot(
                controller: screenshotController,
                child: Column(children: [
                  Image.asset("assets/profile.png", height: 200),
                  const Text("Wataru Yamashita",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          height: 2.5)),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("所属:",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("Flutter株式会社",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ]),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("電話:",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text("090-XXXX-XXX",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                        ]),
                  ),
                ]),
              ),

              // Text("連絡先情報"),
              ListTile(
                  leading: TextButton(
                      onPressed: () async {
                        launchURL(
                            'mailto:${mailAdress}?subject=${mailTitle}&body=${mailContents}');
                      },
                      child: const Icon(Icons.mail)),
                  title: const Text("連絡先情報",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("メールアドレス: ooo@ooo.ooo",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              ListTile(
                leading: TextButton(
                  onPressed: () async {
                    launchURL(webSite);
                  },
                  child: const Icon(Icons.public),
                ),
                title: const Text("HP",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(webSite,
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
