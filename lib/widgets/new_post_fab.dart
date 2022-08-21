import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../screens/post_entry.dart';

class NewPostButton extends StatelessWidget{
  File? image;
  final picker = ImagePicker();

  Future getImageFile() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);
  }
  Widget build(BuildContext context){
    return FloatingActionButton(
      child:const Icon(Icons.photo_camera),
      onPressed: () async {
        //uploadData();
        await getImageFile();
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostEntry(image: image!)),
        );
      },
    );
  }
}