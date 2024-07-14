import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_auth/presentation/pages/comment/comments_controller.dart';

class CommentsPage extends StatelessWidget {
  final String bourd_id;
  final String? title;
  final CommentsController commentsController;

  CommentsPage({
    required this.bourd_id,
    this.title,
  })  : commentsController = Get.put(CommentsController(bourd_id));

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
              if (commentsController.board.value == null) { /* 게시물이 빈 값일 경우 */
                return Center(child: CircularProgressIndicator());
              }
              var bourd = commentsController.board.value!;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 게시판 본문
                      commentsController.googleAuthController.getUser!.email == bourd['author'] ?
                      IconButton(
                          onPressed: () {
                            print("수정 실행");
                          },
                          icon: Icon(Icons.edit),
                      ) : Text(''),
                      Text(
                          bourd['title'],
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                      ),
                      SizedBox(height: 8),
                      Text(
                          '작성자: ${bourd['author']}',
                          style: TextStyle(fontSize: 16, color: Colors.grey)
                      ),
                      SizedBox(height: 16),
                      Text(
                          bourd['content'],
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
                      ...commentsController.commentsModels.map((comment) {
                        return ListTile(
                          title: Text(comment.content),
                          subtitle: Text('작성자: ${comment.author}'),
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
  Future<void> updateAlert(BuildContext context, String id) async {
    return showDialog<void>(
      //다이얼로그 위젯 소환
      context: context,
      barrierDismissible: false, // 다이얼로그 이외의 바탕 눌러도 안꺼지도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('수정'),
          content: SingleChildScrollView(
            child: ListBody(
              //List Body를 기준으로 Text 설정
              children: <Widget>[
                Text('정말 수정하시겠습니까?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('예'),
              onPressed: () {
                print("댓글 수정");
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
