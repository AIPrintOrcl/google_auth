import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

// 전역변수
class ReactiveCommonController extends GetxController {
  // 로그인한 유저 정보
  late User? _user;
  get getUser => _user;

  setUser(User? user) {
    _user = user;
  }
}

// getx. 으로 바로 호출 가능
final getx = Get.put(ReactiveCommonController());