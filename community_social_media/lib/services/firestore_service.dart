import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:community_social_media/models/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_storage/firebase_storage.dart';

class FirestoreService {
  final firestoreService = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  Future<void> createUser(String username) async {
    print("girdi");
    await firestoreService
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .set({"name": username});
  }

  Future<void> createPost(PostModel postModel) async {
    var docId = firestoreService.collection("posts").doc().id;
    postModel.postId = docId;
    await firestoreService
        .collection("posts")
        .doc(docId)
        .set(postModel.toJson());
  }

  Future<String> uploadImage(File fileName) async {
    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    var taskSnapshot =
        await storage.ref().child('post_images/$imageName').putFile(fileName);
    var url = await taskSnapshot.ref.getDownloadURL();
    return url;
  }

  Future<String> getUserName() async {
    var data = await firestoreService
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .get();
    return data.data()!['name'];
  }
}
