import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_auth/presentation/pages/credit/credit_page.dart';
import 'package:google_auth/presentation/pages/login/login_page.dart';
// import 'package:ggnz/presentation/pages/credit/credit_page.dart';
// import 'package:ggnz/presentation/widgets/buttons/button_ggnz.dart';
// import 'package:ggnz/presentation/pages/wallet/make_wallet_page.dart';
// import 'package:ggnz/utils/audio_controller.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'dart:io';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  // 알림창
  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
                'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
                'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final mainPageController = Get.put(MainPageController());
    return Scaffold(
      body: Obx(
            () => Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bg2.gif'),
            ),
          ),
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Spacer(flex: 1),
                  mainPageController.isShowTitle
                      ? Image.asset(
                    'assets/title.gif',
                  )
                      : Container(),
                  const Spacer(flex: 1),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 800),
                    switchInCurve: Curves.easeIn,
                    child: mainPageController.isShowButton
                        ? Column(
                      children: [
                        // 시작하기 버튼
                        TextButton(
                          child: Text("시작하기"),
                          onPressed: () {
                            Get.off(() => LoginPage(),
                                transition: Transition.fadeIn,
                                duration:
                                const Duration(milliseconds: 500));
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // Credit 버튼
                        TextButton(
                          child: Text("Credit"),
                          onPressed: () {
                            Get.to(() => const CreditPage(),
                                transition: Transition.fadeIn,
                                duration:
                                const Duration(milliseconds: 500));
                          },
                        ),
                      ],
                    )
                        : Container(height: 50),
                  ),
                  const Spacer(flex: 4),
                ]),
          ),
        ),
      ),
    );
  }
}

class MainPageController extends GetxController {
  RxBool _isShowTitle = false.obs;
  bool get isShowTitle => _isShowTitle.value;
  RxBool _isShowButton = false.obs;
  bool get isShowButton => _isShowButton.value;

  @override
  void onInit() {
    Future.delayed(
        Duration(milliseconds: 300), (() => _isShowTitle.value = true));
    Future.delayed(
        Duration(milliseconds: 1500), (() => _isShowButton.value = true));
    super.onInit();
  }
}