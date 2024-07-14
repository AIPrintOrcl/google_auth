import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_auth/presentation/pages/bulletinBoard/bulletin_bord_page.dart';
import 'package:google_auth/presentation/pages/login/google_auth_controller.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_auth/presentation/pages/main_page.dart';
import 'package:google_auth/presentation/pages/login/login_page.dart';

class BulletinBordController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentsController = TextEditingController();
  final googleAuthController = GoogleAuthController.instance;

  @override
  void onInit() {
    super.onInit();
    getBulletinBord();
  }

  // DB 관련
  RxList<BulletinBordModel> _bulletinBordModels = RxList<BulletinBordModel>([]);
  List<BulletinBordModel> get bulletinBordModels => _bulletinBordModels;
  //cloud firestore
  final FirebaseFirestore db = FirebaseFirestore.instance;

  getBulletinBord() {
    db.collection('bulletinBoard').snapshots().listen((snapshot) {
      _bulletinBordModels.value = snapshot.docs.map((doc) {
        return BulletinBordModel(
          id: doc.id,
          title: doc['title'],
          content: doc['content'],
          author: doc['author'],
          like_count: doc['like_count'],
          create_date: doc['create_date'],
        );
      }).toList();
    });
  }

  void addBulletinBord() {
    db.collection('bulletinBoard').add({
      'title': titleController.text,
      'content': contentsController.text,
      'author': googleAuthController.getUser!.email,
      'like_count': 0,
      'create_date': FieldValue.serverTimestamp(),
    });
    titleController.clear();
    contentsController.clear();
  }

  void deleteBulletinBord(String id) async {
    var documentReference = db.collection('bulletinBoard').doc(id);
    await documentReference.delete().whenComplete(() {
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  void updateBulletinBord(String id, data) async {
    var documentReference = db.collection('bulletinBoard').doc(id);
    await documentReference.update(data).whenComplete(() {
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

}

// Model
class BulletinBordModel {
  BulletinBordModel( /* 생성자 */
      {required this.id,
        required this.title,
        required this.content,
        required this.author,
        required this.like_count,
        required this.create_date
      });

  String id;
  String title;
  String content;
  String author;
  num like_count;
  Timestamp create_date;

  factory BulletinBordModel.fromJson(Map<String, dynamic> json) => BulletinBordModel( /* json => 데이터로 변환 */
      id: json["id"],
      title: json["title"],
      author: json["author"],
      content: json["content"],
      like_count: json["like_count"],
      create_date: json["create_date"],
  );

  Map<String, dynamic> toJson() => { /* 데이터 => json로 변환 */
    "id": id,
    "title": title,
    "author": author,
    "content": content,
    "like_count": like_count,
    "create_date": create_date
  };
}