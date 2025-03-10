import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_page.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class AnimatedSplashScreenWidget extends StatelessWidget {
  const AnimatedSplashScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            SizedBox(height: 10),
            Text(
              'Encrypt Health Center',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 40),
            Lottie.asset('assets/ambulance.json', height: 150),
            SizedBox(height: 20),
            CircularProgressIndicator(),
            Spacer(),
          ],
        ),
      ),
      nextScreen: LoginPage(),
      splashIconSize: 300,
      backgroundColor: Colors.grey[300]!,
      duration: 1000,
    );
  }
}
