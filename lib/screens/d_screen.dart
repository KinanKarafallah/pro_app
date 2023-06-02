import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io' as F;

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  String imageUrl;
  Future uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile image;
   

    
    image = await _imagePicker.getImage(source: ImageSource.gallery);
    var file = F.File(image.path);

    if (image != null) {
      var snapshot =
          await _firebaseStorage.ref().child('images').putFile(file).onComplete;
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });
    } else {
      print('No Image Path Received');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diagnose',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
                border: Border.all(color: Colors.white),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(2, 2),
                    spreadRadius: 2,
                    blurRadius: 1,
                  ),
                ],
              ),
              child: (imageUrl == null)
                  ? Text('image not choosed')
                  : Container(
                      height: 350,
                      width: 350,
                      padding: EdgeInsets.all(5),
                      margin: EdgeInsets.all(5),
                      child: Image.network(imageUrl),
                      decoration: new BoxDecoration(
                        border: Border.all(color: Colors.purple, width: 3),
                        borderRadius: BorderRadius.all(
                          Radius.elliptical(4, 5),
                        ),
                      ),
                    ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              child: Text("Upload Image",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              onPressed: uploadImage,
            ),
          ],
        ),
      ),
    );
  }
}
