import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/postData.dart';
import 'package:location/location.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);
  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  File? image;
  String? finalUrl;
  LocationData? locationData;
  var locationService = Location();
  final picker = ImagePicker();
  var _formKey = GlobalKey<FormState>();
  final post = WriteToDB();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);
    setState(() {});
    uploadPhotoToStorage();
  }

  Future uploadPhotoToStorage() async {
    var imageUrl = 'http://' + DateTime.now().toString() + '.jpg';
    Reference storageReferenceImage =
        FirebaseStorage.instance.ref().child(imageUrl);

    UploadTask uploadTask = storageReferenceImage.putFile(image!);

    await uploadTask;
    finalUrl = await storageReferenceImage.getDownloadURL();
    print(finalUrl);
  }

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
    try {
      var _serviceEnabled = await locationService.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await locationService.requestService();
        if (!_serviceEnabled) {
          print('Failed to enable service. Returning.');
          return;
        }
      }

      var _permissionGranted = await locationService.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await locationService.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location service permission not granted. Returning.');
        }
      }

      locationData = await locationService.getLocation();
    } on PlatformException catch (e) {
      print('Error: ${e.toString()}, code: ${e.code}');
      locationData = null;
    }
    locationData = await locationService.getLocation();
    getImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      getImage();
      print('In image null');
      return Center(child: CircularProgressIndicator());
    } else {
      print('Made it to main build');
      return Scaffold(
        appBar: AppBar(title: Text('New Post')),
        body: Center(
          child: Column(
            children: [
              Image.file(image!),
              SizedBox(height: 50),
              Center(
                child: Form(
                  key: _formKey,
                  child: new TextFormField(
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        hintText: "Number of wasted items",
                        hintStyle: TextStyle(fontSize: 20)),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter a quantity";
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      post.quantity = int.parse(value!);
                      // Hard Coded long at lat in due to issue w/platform
                      // https://edstem.org/us/courses/6815/discussion/554032
                      post.longitude = '30.04443 N';
                      post.latitude = '118.2508 W';
                      post.imgurl = finalUrl;
                      // post.longitude = locationData!.longitude;
                      // post.latitude = locationData!.latitude;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: uploadToDB(context),
      );
    }
  }

  Widget uploadToDB(BuildContext context) {
    return GestureDetector(
      child: Container(
          height: 150,
          color: Colors.blue,
          child: Icon(Icons.cloud_upload, size: 50)),
      onTap: () async {
        var formatting = DateFormat('EEEE, MMMM d, y');
        post.date = formatting.format(DateTime.now());
        if (_formKey.currentState!.validate()) {
          _formKey.currentState!.save();
          FirebaseFirestore.instance.collection('posts').add({
            'date': post.date,
            'latitude': post.longitude,
            'longitude': post.latitude,
            'quantity': post.quantity,
            'imgurl': post.imgurl,
          });
          Navigator.of(context).pop();
        }
      },
    );
  }
}
