import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_auth/presentation/pages/bulletinBoard/bulletin_bord_controller.dart';
import 'package:google_auth/presentation/pages/bulletinBoard/bulletin_bord_create_page.dart';
import 'package:google_auth/presentation/pages/comment/comments_page.dart';
import 'package:google_auth/presentation/pages/login/auth_controller.dart';
import 'package:google_auth/presentation/pages/login/google_auth_controller.dart';
import 'package:google_auth/utils/getx_controller.dart';

class BulletinBordPage extends StatelessWidget {
  final bulletinBordController = Get.put(BulletinBordController());
  final googleAuthController = GoogleAuthController.instance;

  @override
  Widget build(BuildContext context) {
    final googleController = bulletinBordController.googleAuthController;
    final authController = Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(
        title: Text('게시판'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // 확인 메시지를 위한 세팅
              bulletinBordController.checkTitle();
              bulletinBordController.checkContent();

              Get.to(() => BulletinBordCreatePage());
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              authController.logOut();
              googleController.signOut();
              // if(googleController.getGoogleSignIn.signIn() != null){
              //   googleController.signOut();
              //   return;
              // }
              // if(authController.getUser != null){
              //   authController.logOut();
              //   return;
              // }
            },
          ),
        ],
      ),
      body: Column( /// 게시판 리스트
        children: [
          Expanded(
            child: Obx(() {
              if (bulletinBordController.bulletinBordList.isEmpty) { /* 게시물이 빈 값일 경우 */
                return Center(child: CircularProgressIndicator());
              }
              return ListView.separated(
                padding: EdgeInsets.zero,
                controller: ScrollController(),
                itemCount: bulletinBordController.bulletinBordList.length,
                itemBuilder: (BuildContext context, int index) {
                  var board = bulletinBordController.bulletinBordList[index];
                  return ListTile(
                    title: Text(board.title),
                    subtitle: Text(board.author),
                    /// 작성자만 삭제 기능 표시
                    trailing: getx.getUser.email ==
                        board.author ?
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteAlert(context, board.id);
                      },
                    ) : Text(''),
                    onTap: () {
                      Get.to(() => CommentsPage(
                        board_id: board.id,
                        title: board.title,
                      ),
                          arguments: true, /* 전달할 인자 설정 */
                          duration: const Duration(milliseconds: 500) /* 페이지 전환 지연 시간 설정 500 = 0.5초 */
                      );
                    }
                    /*{Get.to(() => CommentsPage(
                      board_id: board.id,
                      title: board.title,
                    ));}*/,
                  );
                },
                separatorBuilder: (BuildContext context, int index) => const Divider(),
              );
            }),
          ),
        ],
      ),
    );
  }

  // 삭제 확인창
  Future<void> deleteAlert(BuildContext context, String id) async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제'),
          content: SingleChildScrollView(
            child: ListBody(
              //List Body를 기준으로 Text 설정
              children: <Widget>[
                Text('정말 삭제하시겠습니까?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('예'),
              onPressed: () {
                bulletinBordController.deleteBulletinBord(id);
                Navigator.of(context).pop();
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