import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../bloc/authbloc/auth_bloc.dart';
import '../const.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({Key? key}) : super(key: key);

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isChecked = false;
  String token = "";
  @override
  Widget build(BuildContext context) {
    final FormState? form = _formKey.currentState;
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Do you want to exit an App?'),
              actions: [
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.pink)),
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: const Text('No'),
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.pink)),
                  onPressed: () => SystemNavigator.pop(),
                  //return true when click on "Yes"
                  child: const Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: SafeArea(
              child: Scaffold(
                backgroundColor: Colors.white,
                body: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Lottie.asset("assets/lottie/103657-user.json",
                          height: 200),
                      SizedBox(height: 10.h),
                      Center(
                        child:  Text("What's your Name ?",
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xff301934))),
                      ),
                       SizedBox(height: 5.h),
                      ProfileTextFields(
                        controller: username,
                        hinttext: ' User Name',
                        title: ' ',
                        textAlign: TextAlign.start,
                        validator: (value) {},
                      ),
                      const Spacer(),
                      Center(
                        child: GestureDetector(
                          onTap: () async {

                            BlocProvider.of<AuthBloc>(context).add(
                              SaveUserDetails(
                                user: username.text,
                              ),
                            );
                          },
                          child: Container(
                            height: 50.h,
                            width: 120.w,
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(20)),
                                gradient: LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  stops: const [
                                    0.1,
                                    0.4,
                                    0.6,
                                    0.9,
                                  ],
                                  colors: [
                                    Colors.purple.shade600,
                                    Colors.purple.shade300,
                                    Colors.purple.shade600,
                                    Colors.purple.shade300,
                                  ],
                                )),
                            child:  Center(
                              child: Text(
                                "Done",
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
