import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import '../models/new_post.dart';
import '../widgets/new_post_fab.dart';
import 'post_detail.dart';

class PostEntries extends StatefulWidget {
  
  @override
  _PostEntriesState createState() => _PostEntriesState();
}

class _PostEntriesState extends State<PostEntries> {
  File? image;
  final picker = ImagePicker();

  Future getImageFile() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    image = File(pickedFile!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Wasteagram')
      ),
      body: wasteagramStreamBuilder(context),
      floatingActionButton: NewPostButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget wasteagramStreamBuilder(BuildContext context){
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('posts').orderBy('created', descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData &&
            snapshot.data!.docs != null &&
            snapshot.data!.docs.length > 0) {
          return wasteagramListView(context, snapshot);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }

  Widget wasteagramListView(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var post = snapshot.data!.docs[index];
              return GestureDetector(
                child: ListTile(
                  leading: Text(post['title'], style: const TextStyle(fontSize: 20)),
                  trailing: Text(post['itemCount'].toString(), style: const TextStyle(fontSize: 20)),
                onTap: (){
                  final pst = NewPost(title:post['title'],
                                      url:post['url'],
                                      itemCount: post['itemCount'],
                                      postLocation: post['postLocation']);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostDetail(post:pst)),
                  );
                },
                ),
              );
            },
          )
        ),
      ],
    );
  }

}