import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'like_count.dart';
import 'package:hive/hive.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  Hive.registerAdapter(LikeCountAdapter());

  runApp(ProfileApp());
}

class ProfileApp extends StatefulWidget {
  ProfileApp({super.key});

  @override
  State<ProfileApp> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FutureBuilder(
          future: Hive.openBox<LikeCount>('countBox'),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError)
                return Text(snapshot.error.toString());
              else
                return Home();
            } else
              return Scaffold();
          }),
    );
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }
}

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

//   Future<dynamic> ShowCaptureWidget(
//       BuildContext context, Uint8List.capturedImage) {
//
// }
  late Box box;
  @override
  void initState() {
    super.initState();
    box = Hive.box<LikeCount>('countBox');
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<LikeCount>>(
      valueListenable: Hive.box<LikeCount>('countBox').listenable(),
      builder: (context, countBox, _) {
        return Scaffold(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            int ctemp = box
                                    .get('countBox',
                                        defaultValue: LikeCount(likeCount: 0))!
                                    .likeCount +
                                1;
                            box.put('countBox', LikeCount(likeCount: ctemp));
                            print(ctemp);
                          },
                          child: Icon(Icons.favorite),
                        ),
                        Text(
                          '${countBox.get('countBox', defaultValue: LikeCount(likeCount: 0))!.likeCount} likes',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
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
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
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
        );
      },
    );
  }
}