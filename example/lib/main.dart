import 'dart:io';

import 'package:chatwoot_sdk/chatwoot_sdk.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;
import 'package:image_picker/image_picker.dart' as image_picker;
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatwoot Example"),
        actions: [
          IconButton(
              onPressed: () {
                ChatwootChatDialog.show(
                  context,
                  baseUrl: "<baseUrl here>",
                  inboxIdentifier: "<inboxIdentifier here>",
                  title: "Chatwoot Support",
                  user: ChatwootUser(
                      identifier: "john@gmail.com",
                      name: "John Samuel",
                      email: "john@gmail.com",
                      phoneNumber: '+233xxxxxxx',
                      avatarUrl:
                          'https://plus.unsplash.com/premium_photo-1690579805307-7ec030c75543?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80'),
                );
              },
              icon: Icon(Icons.message))
        ],
      ),
      body: SafeArea(
        child: ChatwootChat(
          baseUrl: "<baseUrl here>",
          inboxIdentifier: "<inboxIdentifier here>",
          user: ChatwootUser(
              identifier: "john@gmail.com",
              name: "John Samuel",
              email: "john@gmail.com",
              phoneNumber: '+233xxxxxxx',
              avatarUrl:
                  'https://plus.unsplash.com/premium_photo-1690579805307-7ec030c75543?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80'),
          showUserAvatars: true,
          showUserNames: true,
        ),
      ),
    );
  }

  Future<List<String>> _androidFilePicker() async {
    final picker = image_picker.ImagePicker();
    final photo = await picker.pickImage(source: image_picker.ImageSource.gallery);

    if (photo == null) {
      return [];
    }

    final imageData = await photo.readAsBytes();
    final decodedImage = image.decodeImage(imageData);
    final scaledImage = image.copyResize(decodedImage!, width: 500);
    final jpg = image.encodeJpg(scaledImage, quality: 90);

    final filePath = (await getTemporaryDirectory()).uri.resolve(
          './image_${DateTime.now().microsecondsSinceEpoch}.jpg',
        );
    final file = await File.fromUri(filePath).create(recursive: true);
    await file.writeAsBytes(jpg, flush: true);

    return [file.uri.toString()];
  }
}
