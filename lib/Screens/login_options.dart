import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinderapp/Screens/startScreen.dart';
import 'package:tinderapp/Screens/user_details.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../auth/gooleauthentication.dart';
import '../auth/sign_up_screen.dart';
import '../controller/gmail_controller.dart';

class LoginOptions extends StatefulWidget {
  const LoginOptions({Key? key}) : super(key: key);

  @override
  State<LoginOptions> createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  GmailController gmailController = GmailController();
  bool _isSigningIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height.h,
        child: Stack(
          children: [
            WaveWidget(
              backgroundColor: Colors.white,
              config: CustomConfig(
                gradients: [
                  [
                    Colors.purple.withOpacity(0.2),
                    Colors.purple.withOpacity(0.3)
                  ],
                  [
                    Colors.purple.withOpacity(0.2),
                    Colors.purple.withOpacity(0.3),
                  ],
                ],
                durations: [12303, 10800],
                heightPercentages: [0.20, 0.28],
                blur: const MaskFilter.blur(BlurStyle.solid, 20),
              ),
              waveAmplitude: 2,
              size: Size(
                MediaQuery.of(context).size.width.w,
                MediaQuery.of(context).size.height.h,
              ),
            ),
            Lottie.asset(
              'assets/lottie/lover-people-sitting-on-garden-banch.json',
              height: MediaQuery.of(context).size.width.w,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3.h,
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Text(
                        "Let's meet new \npeople around you",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff301934)),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(const SignUp());
                    },
                    child: Container(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width * 0.8.w,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: const BoxDecoration(
                          color: Color(0xff301934),
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20.r,
                            child: const Icon(Icons.wifi_calling_3_outlined,
                                color: Color(0xff301934)),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1.w),
                          Text(
                            "Login with phone",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      setState(() {
                        _isSigningIn = true;
                      });
                      try {
                        User? user = await Authentication.signInWithGoogle(
                            context: context);
                        setState(() {
                          _isSigningIn = false;
                        });
                        if (user != null) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('isSignedIn', true);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const UserDetails(),
                            ),
                          );
                        }
                      } on PlatformException catch (error) {
                        print("::::::::::::::::::::::::${error.code}");
                      }
                    },
                    child: Container(
                      height: 60.h,
                      width: MediaQuery.of(context).size.width * 0.8.w,
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(30))),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 20.r,
                            child: Image.asset(
                              "assets/icons/google.png",
                              height: 30.h,
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.1.w),
                          Text(
                            "Login with Google",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: const Color(0xff301934),
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account ?",
                          style: TextStyle(fontSize: 16.sp)),
                      TextButton(
                        onPressed: () {
                          Get.to(const StartScreen());
                        },
                        child: Text('Sign up',
                            style: TextStyle(
                                fontSize: 18.sp, color: Colors.purple.shade50)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
