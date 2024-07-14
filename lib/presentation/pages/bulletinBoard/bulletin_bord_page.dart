import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_auth/presentation/pages/bulletinBoard/bulletin_bord_controller.dart';
import 'package:google_auth/presentation/pages/bulletinBoard/bulletin_bord_create_page.dart';
import 'package:google_auth/presentation/pages/comment/comments_page.dart';

class BulletinBordPage extends StatelessWidget {
  final bulletinBordController = Get.put(BulletinBordController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('게시판'),
        actions: [
          IconButton(
            icon: Icon(Icons.create),
            onPressed: () {
              Get.to(() => BulletinBordCreatePage());
            },
          ),
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
            child: Obx(() {
              if (bulletinBordController.bulletinBordModels.isEmpty) { /* 게시물이 빈 값일 경우 */
                return Center(child: CircularProgressIndicator());
              }
              return ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: bulletinBordController.bulletinBordModels.length,
                itemBuilder: (BuildContext context, int index) {
                  var bourd = bulletinBordController.bulletinBordModels[index];
                  return ListTile(
                    title: Text(bourd.title),
                    subtitle: Text(bourd.author),
                    /// 작성자만 삭제 기능 표시
                    trailing: bulletinBordController.googleAuthController.getUser!.email ==
                        bourd.author ? IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        deleteAlert(context, bourd.id);
                      },
                    ) : Text(''),
                    onTap: () {Get.to(() => CommentsPage(
                      bourd_id: bourd.id,
                      title: bourd.title,
                    ));},
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