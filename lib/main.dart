import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String imagelink;
  File image;
  ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 64,
            ),
            imagelink != null
                ? CircleAvatar(
                    child: ClipOval(
                      child: Image.network(imagelink),
                    ),
                    radius: 100,
                  )
                : buildCircleAvatar(),
            SizedBox(
              height: 16,
            ),
            FlatButton(
              textColor: Colors.white,
              color: Colors.green,
              onPressed: () async {
                PickedFile pickedFile =
                    await picker.getImage(source: ImageSource.gallery);
                File images = File(pickedFile.path);
                FirebaseStorage storage = FirebaseStorage.instance;
                StorageReference reference = storage.ref();
                String fileName = basename(images.path);
                StorageReference pictureFolder = reference.child(fileName);
                pictureFolder.putFile(images).onComplete.then((value) async {
                  String link = await value.ref.getDownloadURL();
                  setState(() {
                    imagelink = link;
                  });
                });
              },
              child: Text(
                'Change Image',
              ),
            ),
          ],
        ),
      ),
    );
  }

  CircleAvatar buildCircleAvatar() {
    return CircleAvatar(
      child: ClipOval(
        child: Icon(
          Icons.person,
          size: 100,
        ),
      ),
      radius: 100,
    );
  }
}
