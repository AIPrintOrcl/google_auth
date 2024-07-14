import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_auth/presentation/pages/login/google_auth_controller.dart';


class CommentsController extends GetxController {
  final TextEditingController textEditingController = TextEditingController();
  final googleAuthController = GoogleAuthController.instance;

  final String bourd_id;

  CommentsController(this.bourd_id);

  @override
  void onInit() {
    super.onInit();
    getBulletinBoard();
    getComments();
  }

  // DB 관련
  Rx<Map<String, dynamic>?> board = Rx<Map<String, dynamic>?>(null);
  RxList<CommentModel> _commentsModels = RxList<CommentModel>([]);
  List<CommentModel> get commentsModels => _commentsModels;
  //cloud firestore
  final FirebaseFirestore db = FirebaseFirestore.instance;

  void getBulletinBoard() {
    db.collection('bulletinBoard').doc(bourd_id).snapshots().listen((snapshot) {
      board.value = snapshot.data();
    });
  }

  getComments() {
    db.collection('bulletinBoard').doc(bourd_id).collection('comments').snapshots().listen((snapshot) {
      _commentsModels.value = snapshot.docs.map((doc) {
        return CommentModel(
          id: doc.id,
          content: doc['content'],
          author: doc['author'],
          like_count: doc['like_count'],
          create_date: doc['create_date'],
        );
      }).toList();
    });
  }

  void addComment() {
    db.collection('bulletinBoard').doc(bourd_id).collection('comments').add({
      'content': textEditingController.text,
      'author': googleAuthController.getUser!.email,
      'like_count': 0,
      'create_date': FieldValue.serverTimestamp(),
    });
    textEditingController.clear();
  }

  void deleteComment(String id) async {
    var documentReference = db.collection('bulletinBoard').doc(id);
    await documentReference.delete().whenComplete(() {
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  // void updateComment(String id, data) async {
  //   db.collection('bulletinBoard').doc(bourd_id).update(data)({
  //     'title': titleController.text,
  //     'content': contentsController.text,
  //     'author': googleAuthController.getUser!.email,
  //     'like_count': 0,
  //     'create_date': FieldValue.serverTimestamp(),
  //   });
  // }
}

// Model
class CommentModel {
  CommentModel( /* 생성자 */
      { required this.id,
        required this.content,
        required this.author,
        required this.like_count,
        required this.create_date
      });

  String id;
  String content;
  String author;
  num like_count;
  Timestamp create_date;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel( /* json => 데이터로 변환 */
    id: json["id"],
    author: json["author"],
    content: json["content"],
    like_count: json["like_count"],
    create_date: json["create_date"],
  );

  Map<String, dynamic> toJson() => { /* 데이터 => json로 변환 */
    "id": id,
    "author": author,
    "content": content,
    "like_count": like_count,
    "create_date": create_date
  };
}