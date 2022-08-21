import 'package:flutter/material.dart';
import '../models/new_post.dart';

class PostDetail extends StatelessWidget{
  NewPost post;
  PostDetail({required this.post});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title:const Text('Wasteagram'), centerTitle: true,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 700,
          width: double.infinity,
          child:Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(post.title!, style: const TextStyle(fontSize: 30)),
              Image.network(post.url!),
              Text('Items: ${post.itemCount!}', style: const TextStyle(fontSize: 20)),
              Text(post.postLocation!, style: const TextStyle(fontSize: 15)),
            ],
          )
        ),
      ),
    );
  }
}