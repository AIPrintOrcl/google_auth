import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_auth/presentation/pages/bulletinBoard/bulletin_bord_controller.dart';
import 'package:google_auth/presentation/pages/bulletinBoard/bulletin_bord_page.dart';

class BulletinBordCreatePage extends StatelessWidget {
  final String? board_id;

  final bulletinBordController = Get.put(BulletinBordController());

  BulletinBordCreatePage({
    this.board_id,
  });

  @override
  Widget build(BuildContext context) {
    bulletinBordController.titleController.clear();
    bulletinBordController.contentsController.clear();

    if (board_id != null && bulletinBordController.board.value == null) { /* 게시물 번호는 있지만 게시물이 빈 값일 경우 */
      return Center(child: CircularProgressIndicator());
    }

    if(board_id != null){
      bulletinBordController.setTextField(board_id!);
    }

    return Scaffold(
      appBar: AppBar(
        title:  board_id == null ? Text('게시판 생성') : Text('게시판 수정'),
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
                      board_id == null ? checkAlert(context, 'C') : checkAlert(context, 'U');
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
  Future<void> checkAlert(BuildContext context, String mod) {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: mod=='C' ? Text('게시판 생성') : Text('게시판 수정'),
          content: SingleChildScrollView(
            child: ListBody(
              //List Body를 기준으로 Text 설정
              children: <Widget>[
                mod=='C' ? Text('정말 게시판을 생성하시겠습니까?') : Text('정말 게시판을 수정하시겠습니까?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('예'),
              onPressed: () {
                if(mod=='C'){
                  bulletinBordController.addBulletinBord({
                    'title': bulletinBordController.titleController.text,
                    'content': bulletinBordController.contentsController.text,
                    'author': bulletinBordController.googleAuthController.getUser!.email,
                    'like_count': 0,
                    'update_date': FieldValue.serverTimestamp(),
                    'create_date': FieldValue.serverTimestamp(),
                  });
                } else {
                  bulletinBordController.updateBulletinBord(
                    board_id!,
                    {
                      'title': bulletinBordController.titleController.text,
                      'content': bulletinBordController.contentsController.text,
                      'author': bulletinBordController.googleAuthController.getUser!.email,
                      'update_date': FieldValue.serverTimestamp(),
                    },
                  );
                }
                Navigator.of(context).pop();
                Get.off(() => BulletinBordPage(), /* Get.off : 페이지 이동, 이동 효과 및 지연 시간 설정 */
                    arguments: true, /* 전달할 인자 설정 */
                    transition: Transition.fadeIn, /* transition : 페이지 전환 효과 설정, fadeIn : 부드럽게 */
                    duration: const Duration(milliseconds: 500) /* 페이지 전환 지연 시간 설정 500 = 0.5초 */
                );
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