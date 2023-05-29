import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:tinderapp/Screens/login_options.dart';
import 'package:tinderapp/auth/sign_up_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/lottie/firstScreen.json"),
           Text("Make friends with the \npeople like you",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: const Color(0xff301934),
                  fontWeight: FontWeight.w700,
                  fontSize: 24.sp)),
          const SizedBox(height: 20),
          Text(
            "Interact with the poeple like same \ninterests like you.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.purple.shade300),
          ),
           SizedBox(height: 20.h),
          GestureDetector(
            onTap: () {
              Get.to( SignUp());
            },
            child: Container(
              height: 60.h,
              width: MediaQuery.of(context).size.width * 0.8.w,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                  color: Color(0xff301934),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child:  Text("Sign up",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,fontSize: 18.sp)),
            ),
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: () {
              Get.to(const LoginOptions());
            },
            child: Container(
              height: 60.h,
              width: MediaQuery.of(context).size.width * 0.8.w,
              padding: const EdgeInsets.all(18),
              decoration:  BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: const BorderRadius.all(Radius.circular(30))),
              child:  Text("Sign in",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: const Color(0xff301934),fontSize: 18.sp,fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
