import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_auth/firebase_options.dart';
import 'package:google_auth/presentation/pages/login/auth_controller.dart';
import 'package:google_auth/presentation/pages/login/google_auth_controller.dart';
import 'package:google_auth/presentation/pages/main_page.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   name: "auth-4b085",
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // runApp(MyApp());

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown, /* 앱의 화면 방향을 세로 방향으로 고정 */
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Firebase App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
      initialBinding: BindingsBuilder((() { /* initialBinding : 애플리케이션 시작 시 필요한 초기화 작업을 수행하는 바인딩(확정) 설정 */
      /* BindingsBuilder : 다양한 컨트롤러들을 GetX의 의존성 관리 시스템에 등록. */
        Get.put(GoogleAuthController());
        Get.put(AuthController());
    })),
    );
  }
}