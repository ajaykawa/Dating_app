import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../bloc/authbloc/auth_bloc.dart';
import '../utils/navigationbar.dart';

class YourInterest extends StatefulWidget {
  const YourInterest({Key? key}) : super(key: key);

  @override
  State<YourInterest> createState() => _YourInterestState();
}

class _YourInterestState extends State<YourInterest> {
  List<String> interests = [
    'Sports',
    'Music',
    'Food',
    'Travel',
    'Art',
    'Books',
    'Movies',
    'Gaming',
    'Fashion',
    'Fitness',
    'Technology',
    'Photography',
    'Dancing',
    'Hiking',
    'Cooking'
  ];

  List<Icon> icons = const [
    Icon(
      Icons.sports_baseball,
    ),
    Icon(Icons.music_note,),
    Icon(Icons.fastfood_sharp),
    Icon(Icons.travel_explore),
    Icon(Icons.draw),
    Icon(Icons.menu_book_sharp),
    Icon(Icons.local_movies),
    Icon(Icons.videogame_asset_outlined),
    Icon(Icons.design_services),
    Icon(Icons.fitness_center),
    Icon(Icons.biotech),
    Icon(Icons.photo_camera),
    Icon(Icons.sports_martial_arts_sharp),
    Icon(Icons.forest),
    Icon(Icons.emoji_food_beverage),
  ];

  List<bool> selectedInterests = List.filled(15, false);
  int selectedcount = 0;

  void updateSelectedInterests(int index) {
    setState(
          () {
        if (selectedInterests[index] == false) {
          if (selectedcount < 5) {
            selectedInterests[index] = true;
            selectedcount++;
          }
        } else {
          selectedInterests[index] = false;
          selectedcount--;
        }
      },
    );
  }

  void saveSelectedInterests() async {
    List<String> selected = [];
    for (int i = 0; i < selectedInterests.length; i++) {
      if (selectedInterests[i] == true) {
        selected.add(interests[i]);
      }
    }
    if (selected.length >= 5) {
      final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
      final firebaseAuth = FirebaseAuth.instance;
      final firebaseUser = await firebaseAuth.currentUser;
      final userId = firebaseUser!.uid;
      final DocumentReference user = users.doc(userId);
      await user.set(<String, dynamic>{
        'Interests': selected,
      }, SetOptions(merge: true));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return  MyNavigationBar(i: 3,);
          },
        ),
      );
    } else {
      Get.snackbar("Interests not Selected", "You have to select least 5 interests!");
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Do you want to exit an App?'),
          actions: [
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.purple)),
              onPressed: () => Navigator.of(context).pop(false),
              //return false when click on "NO"
              child: const Text('No'),
            ),
            ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.purple)),
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
      child: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        Text(
                          "'Select up to 5 interests'",
                          style: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,

                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                         SizedBox(
                          height: 30.h,
                        ),
                        GridView.builder(
                          itemCount: interests.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1.1,
                              crossAxisCount: 3),
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                updateSelectedInterests(index);
                              },
                              child: Column(
                                children: [
                                  Container(
                                    height: 60.h,
                                    width: 60.w,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                      color: selectedInterests[index]
                                          ? Colors.purple
                                          : Colors.purple[100],
                                    ),
                                    child: Center(
                                      child: icons[index],
                                    ),
                                  ),
                                   SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    interests[index],
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,color: selectedInterests[index]
                                        ? Colors.purple.shade900
                                        : Colors.purple[100],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                           SizedBox(
                            height: 30.h,
                          ),
                        GestureDetector(
                          onTap: () {
                           saveSelectedInterests();
                          },
                          child: Container(
                            height: 50.h,
                            width: MediaQuery.of(context).size.width.w,
                            decoration:  BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20)),
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
                                    Colors.purple.shade200,
                                    Colors.purple.shade700,
                                  ],
                                )),
                            child:  Center(
                              child: Text(
                                'Continue',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                  color: Colors.white,
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
      ),
    );
  }
}
