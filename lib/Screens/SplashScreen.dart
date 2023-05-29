import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinderapp/Screens/startScreen.dart';
import 'package:tinderapp/utils/navigationbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 8), navigateToNextScreen);
  }

  Future<void> navigateToNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    final nextScreen =
        userId != null ? const MyNavigationBar() : const StartScreen();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xfff5e1e1),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: Lottie.asset(
              'assets/lottie/love-loader.json',
            )),
          ],
        ),
      ),
    );
  }
}
