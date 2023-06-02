import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as F;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DiagnosisScreen extends StatefulWidget {
  @override
  _DiagnosisScreenState createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  String imageUrl = '';

  F.File file;

  Future pickercamera() async {
    final myfile = await ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      if (myfile != null) {
        file = F.File(myfile.path);
        uploadFile();
      } else {
        print('No Image selected!');
      }
    });
  }

  Future uploadFile() async {
    if (file == null) return;

    String _imageName = DateTime.now().millisecondsSinceEpoch.toString();

    firebase_storage.StorageReference reference =
        firebase_storage.FirebaseStorage.instance.ref();
    firebase_storage.StorageReference _refDirImage = reference.child('images');

    firebase_storage.StorageReference referenceImagetoUpload =
        _refDirImage.child(_imageName);
    try {
      await referenceImagetoUpload.putFile(F.File(file.path));
      imageUrl = await referenceImagetoUpload.getDownloadURL();
    } catch (err) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Center(
            child: file == null
                ? Text('image not choosed')
                : Container(
                    height: 400,
                    width: 400,
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(5),
                    child: Image.file(file),
                    decoration: new BoxDecoration(
                        border: Border.all(color: Colors.purple, width: 5),
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(4, 5)))),
          ),
          Container(
            child: TextButton(
              child: Text(
                'Upload',
                style: TextStyle(fontSize: 20, color: Colors.purple),
              ),
              onPressed: () {
                pickercamera();
              },
            ),
          ),
        ],
      )),
    );
  }
}
