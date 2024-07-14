import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_auth/presentation/pages/login/google_auth_controller.dart';
import 'package:google_auth/presentation/pages/login/register_page.dart';

class LoginPage extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final googleAuthController = Get.put(GoogleAuthController());

    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              GoogleAuthController.instance.signInWithGoogle();
            },
            child: Text('Sign in with Google'),
          ),
        ),
      );
    }

}