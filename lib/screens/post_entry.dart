import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/new_post.dart';



class PostEntry extends StatefulWidget {
  File image;
  PostEntry({Key? key, required this.image,});
  @override
  _PostEntryState createState() => _PostEntryState();
}

class _PostEntryState extends State<PostEntry> {
  final formKey = GlobalKey<FormState>();
  final post = NewPost();
  LocationData? locationData;
  var locationService = Location();

  /* retrieves the location */
  Future retrieveLocation() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('New Post'), centerTitle: true,),
      body:Form(
        key: formKey,
        child:Padding(
          padding: const EdgeInsets.all(10),
          child:Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height:250,
                width: double.infinity,
                child: FittedBox(fit: BoxFit.contain, child:Image.file(widget.image)),
              ),
              TextFormField(
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(hintText: "Number of Waste"),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: (value){
                    if(value!.isEmpty){
                      return 'Please enter a valid number';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value){
                    //print(value);
                    post.itemCount = int.parse(value!);
                  }, // Only numbers can be entered
              ),
              ElevatedButton(
                onPressed: () async {
                  if(formKey.currentState!.validate()){
                    await retrieveLocation();
                    //print('retrieved location');
                    formKey.currentState!.save();
                    //print('Longitude:  ${locationData!.longitude}');
                    uploadData();
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Upload')
              )
            ]
          )
        )
      )
    );
  }

  Future getImage() async {
    var fileName = DateTime.now().toString() + '.jpg';
    Reference storageReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = storageReference.putFile(widget.image);
    await uploadTask;
    final url = await storageReference.getDownloadURL();
    print('this is $url');
    return url;
  }

  void uploadData() async {
    post.url = await getImage();
    post.postLocation = '${locationData!.latitude}, ${locationData!.longitude}';
    addDateToPost();
    /* final url = await getImage(widget.image);
    final weight = DateTime.now().millisecondsSinceEpoch % 1000;
    final title = 'Title ' + weight.toString(); */
    FirebaseFirestore.instance
        .collection('posts')
        .add({'title': post.title, 'url': post.url, 'itemCount': post.itemCount, 'postLocation': post.postLocation, 'created':FieldValue.serverTimestamp()});
  }
  void addDateToPost() {
    DateTime now = DateTime.now();
    //print(FieldValue.serverTimestamp());
    var formatter = new DateFormat('EEEE, MMM d, yyyy');
    post.title = formatter.format(now);
  }
}