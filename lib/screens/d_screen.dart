import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'dart:io' as F;

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  String imageUrl;
  File file;
  String _apiResponse = '';
  File _imageFile;
  Future uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile image;

    image = await _imagePicker.getImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
      });
    }
    file = F.File(image.path);

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

  Future<void> diagnose() async {
    try {
      final url = Uri.parse('http://192.168.177.232:8000/upload/');

      final imageFile = file;

      // Create a multipart request
      final request = http.MultipartRequest('POST', url);

      // Attach the image file to the request with the key 'file'
      final imageStream = http.ByteStream(imageFile.openRead());
      final imageSize = await imageFile.length();
      final imageUpload = http.MultipartFile(
        'file',
        imageStream,
        imageSize,
        filename: 'image.jpg',
      );
      request.files.add(imageUpload);

      // Add the 'remark' key to the request body with a value of 4
      request.fields['remark'] = '4';

      // Send the request
      final response = await request.send();

      // Read the response
      if (response.statusCode == 201) {
        final responseString = await response.stream.bytesToString();
        setState(() {
          _apiResponse = responseString;
        });

        // Display response string to user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('API Response'),
              content: Text(responseString),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Error fetching data: $e');
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
      body: SingleChildScrollView(
        child: Center(
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
                child: (_imageFile == null)
                    ? Text('image not choosed')
                    : Container(
                        height: MediaQuery.of(context).size.height / 3,
                        width: MediaQuery.of(context).size.width / 1,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        child: Image.file(
                          _imageFile,
                        ),
                        decoration: new BoxDecoration(
                          border: Border.all(color: Colors.purple, width: 3),
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(4, 5),
                          ),
                        ),
                      ),
              ),
              SizedBox(height: 20),
              if (_apiResponse.isNotEmpty)
                Text(
                  _apiResponse,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
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
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                child: Text("Dignose",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
                onPressed: diagnose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
