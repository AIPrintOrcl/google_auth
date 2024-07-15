import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_auth/presentation/pages/login/google_auth_controller.dart';

class BulletinBordController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentsController = TextEditingController();
  final googleAuthController = GoogleAuthController.instance;

  @override
  void onInit() {
    super.onInit();
    getBulletinBordList();
  }

  // DB 관련
  RxList<BulletinBordModel> _bulletinBordList = RxList<BulletinBordModel>([]);
  List<BulletinBordModel> get bulletinBordList => _bulletinBordList;
  //cloud firestore
  final FirebaseFirestore db = FirebaseFirestore.instance;

  getBulletinBordList() {
    db.collection('bulletinBoard').snapshots().listen((snapshot) {
      _bulletinBordList.value = snapshot.docs.map((doc) {
        return BulletinBordModel(
          id: doc.id,
          title: doc['title'],
          content: doc['content'],
          author: doc['author'],
          like_count: doc['like_count'],
          create_date: doc['create_date'],
          update_date: doc['update_date']
        );
      }).toList();
    });
  }

  Rx<Map<String, dynamic>?> board = Rx<Map<String, dynamic>?>(null);

  Rx<Map<String, dynamic>?> getBulletinBoard(String board_id) {
    db.collection('bulletinBoard').doc(board_id).snapshots().listen((snapshot) {
      board.value = snapshot.data();
    });
    return board;
  }

  setTextField(String board_id){
    if(board_id !=null) {
      board = getBulletinBoard(board_id);

      titleController.text = '${board.value!['title']}';
      contentsController.text = '${board.value!['content']}';
    }

  }

  void addBulletinBord(data) async  {
    await db.collection('bulletinBoard').add(data);
    titleController.clear();
    contentsController.clear();
  }

  void deleteBulletinBord(String board_id) async {
    var documentReference = db.collection('bulletinBoard').doc(board_id);
    await documentReference.delete().whenComplete(() {
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

  void updateBulletinBord(String board_id, data) async {
    var documentReference = db.collection('bulletinBoard').doc(board_id);
    await documentReference.update(data).whenComplete(() {
    }).onError((error, stackTrace) {
      print(error.toString());
    });
  }

}

// Model
class BulletinBordModel {
  final googleAuthController = GoogleAuthController.instance;

  BulletinBordModel( /* 생성자 */
      {required this.id,
        required this.title,
        required this.content,
        required this.author,
        required this.like_count,
        required this.create_date,
        required this.update_date
      });

  String id;
  String title;
  String content;
  String author;
  num like_count;
  Timestamp create_date;
  Timestamp update_date;

  /// 네임드 생성자 이용하여 여러 생성자 생성
  // BulletinBordModel.updateBoardModel(
  //     this.title,
  //     this.content,
  //     this.create_date,
  //     )   : id = '',
  //       author = googleAuthController.getUser.email!,
  //       like_count = 0;

  factory BulletinBordModel.fromJson(Map<String, dynamic> json) => BulletinBordModel( /* json => 데이터로 변환 */
      id: json["id"],
      title: json["title"],
      author: json["author"],
      content: json["content"],
      like_count: json["like_count"],
      create_date: json["create_date"],
      update_date: json["update_date"]
  );

  Map<String, dynamic> toJson() => { /* 데이터 => json로 변환 */
    "id": id,
    "title": title,
    "author": author,
    "content": content,
    "like_count": like_count,
    "create_date": create_date,
    "update_date": update_date
  };
}