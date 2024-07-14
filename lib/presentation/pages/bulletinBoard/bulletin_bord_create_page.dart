import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_auth/presentation/pages/bulletinBoard/bulletin_bord_controller.dart';
import 'package:google_auth/presentation/pages/bulletinBoard/bulletin_bord_page.dart';
import 'package:google_auth/presentation/pages/comment/comments_page.dart';

class BulletinBordCreatePage extends StatelessWidget {
  final bulletinBordController = Get.put(BulletinBordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시판 생성'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              bulletinBordController.googleAuthController.signOut();
            },
          ),
        ],
      ),
      body: Column( /// 게시판 리스트
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: bulletinBordController.titleController,
                        decoration: InputDecoration(
                          labelText: '제목',
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: bulletinBordController.contentsController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: '내용',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    createAlert(context);
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 생성 확인창
  Future<void> createAlert(BuildContext context) {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('게시판 생성'),
          content: SingleChildScrollView(
            child: ListBody(
              //List Body를 기준으로 Text 설정
              children: <Widget>[
                Text('정말 게시판을 생성하시겠습니까?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('예'),
              onPressed: () {
                bulletinBordController.addBulletinBord();
                Navigator.of(context).pop();
                Get.to(() => BulletinBordPage());
              },
            ),
            TextButton(
              child: Text('아니요'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}