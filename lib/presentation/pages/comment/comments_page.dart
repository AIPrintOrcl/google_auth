import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_auth/presentation/pages/bulletinBoard/bulletin_bord_controller.dart';
import 'package:google_auth/presentation/pages/bulletinBoard/bulletin_bord_create_page.dart';
import 'package:google_auth/presentation/pages/bulletinBoard/bulletin_bord_page.dart';
import 'package:google_auth/presentation/pages/comment/comments_controller.dart';

class CommentsPage extends StatelessWidget {
  final String board_id;
  final String? title;
  final CommentsController commentsController;
  final bulletinBordController = Get.put(BulletinBordController());

  CommentsPage({
    required this.board_id,
    this.title,
  })  : commentsController = Get.put(CommentsController(board_id));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$title'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (bulletinBordController.board.value == null) { /* 게시물이 빈 값일 경우 */
                return Center(child: CircularProgressIndicator());
              }
              var board = bulletinBordController.board.value!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 게시판 본문
                      commentsController.googleAuthController.getUser!.email == board['author'] ?
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Get.to(
                                  BulletinBordCreatePage(
                                    board_id: board_id,
                                  ),);
                              },
                              icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            onPressed: () {
                              deleteAlert(
                                  context,
                                  board_id,
                                  'board'
                              );
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ]
                      ) : Text(''),
                      Text(
                          board['title'],
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                      ),
                      SizedBox(height: 8),
                      Text(
                          '작성자: ${board['author']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey)
                      ),
                      SizedBox(height: 16),
                      Text(
                          board['content'],
                          style: TextStyle(fontSize: 18)
                      ),
                      SizedBox(height: 16),
                      Divider(),
                      Text(
                          '댓글',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                      ),
                      SizedBox(height: 8),
                      // 댓글 리스트
                      ...commentsController.commentsList.map((comment) {
                        return ListTile(
                          title: Text(comment.content),
                          subtitle: Text('작성자: ${comment.author}'),
                          trailing: commentsController.googleAuthController.getUser!.email ==
                              comment.author ?
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteAlert(
                                  context,
                                  comment.id,
                                  "comment"
                              );
                            },
                          ) : Text(''),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentsController.textEditingController,
                    decoration: InputDecoration(
                      labelText: '댓글 쓰기',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: commentsController.addComment,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // 수정 확인창
  Future<void> deleteAlert(BuildContext context, String id, String mod) async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('삭제 확인'),
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
                if(mod == "board") {
                  bulletinBordController.deleteBulletinBord(id);
                  Get.off(() => BulletinBordPage(), /* Get.off : 페이지 이동, 이동 효과 및 지연 시간 설정 */
                      arguments: true, /* 전달할 인자 설정 */
                      transition: Transition.fadeIn, /* transition : 페이지 전환 효과 설정, fadeIn : 부드럽게 */
                      duration: const Duration(milliseconds: 500) /* 페이지 전환 지연 시간 설정 500 = 0.5초 */
                  );
                } else if(mod == "comment") {
                  commentsController.deleteComment(id);
                };
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
