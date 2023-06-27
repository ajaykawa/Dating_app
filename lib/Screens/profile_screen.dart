import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:tinderapp/Screens/profile_edit.dart';
import 'package:tinderapp/Screens/setting_screen.dart';
import 'package:tinderapp/data/lists_.dart';
import '../const.dart';
import '../data/explore_json.dart';

double total = 0;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List itemsTemp = [];
  int itemLength = 0;
  @override
  void initState() {
    super.initState();
    getUserLocation();

    setState(() {
      itemsTemp = explore_json;
      itemLength = explore_json.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user =
        FirebaseFirestore.instance.collection('users').doc(userId);
    return StreamBuilder<DocumentSnapshot>(
        stream: user.snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Text("Loading...");
          }
          final Map<String, dynamic>? data =
              snapshot.data!.data() as Map<String, dynamic>?;
          final String? relationType = data?['RelaitonShip Type'];
          final String relationshipgoals = data?['RelaitonShip Goal'];
          final String username = data?['username'];
          final String aboutme = data?['about_me'];
          final saveinterests = data!['Interests'];
          final String languages = data['Languages'];
          final String Pets = data['Pets Like'];
          final String Drinking = data['Drinking Habits'];
          final String Smoking = data['Smoking Habits'];
          final String Diets = data['Diet Preferences'];
          final String job = data['Job Title'];
          final String? company = data['Company Name'];
          final String education = data['Education'];
          final List<String>? images = data['images']?.cast<String>();
          final String? firstImage =
              images != null && images.isNotEmpty ? images[0] : null;
          Future<bool> showExitPopup() async {
            return await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Exit App'),
                    content: const Text('Do you want to exit an App?'),
                    actions: [
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.purple)),
                        onPressed: () => Navigator.of(context).pop(false),
                        //return false when click on "NO"
                        child: const Text('No'),
                      ),
                      ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.purple)),
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
              child: Scaffold(
                backgroundColor: const Color(0xfff1f2f6),
                body: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: size.width.w,
                        height: size.height * 0.35.h,
                        decoration:
                            const BoxDecoration(color: white, boxShadow: []),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, right: 30),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'tinder',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontSize: 32.sp),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) {
                                          return const SettingScreen();
                                        },
                                      ));
                                    },
                                    child: const Icon(
                                      Icons.settings,
                                      color: Colors.grey,
                                      size: 32,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Stack(
                                children: [
                                  CircularPercentIndicator(
                                    radius: 80.0.r,
                                    lineWidth: 8.0,
                                    animation: true,
                                    percent:
                                        total < 99 ? total / 100 + 0.3 : 0.99,
                                    center: CircleAvatar(
                                      radius: 70.r,
                                      backgroundImage:
                                          NetworkImage(firstImage!),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: Colors.pink,
                                  ),
                                  Positioned(
                                    left: 125,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProfileEdit(total: total),
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 20.r,
                                        backgroundColor: Colors.grey.shade100,
                                        child: const Icon(Icons.edit,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5.h),
                              Container(
                                height: 35.h,
                                width: 160.w,
                                decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(20),
                                    ),
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
                                child: Center(
                                  child: Text(
                                      total.toInt() + 30 == 100
                                          ? '100 % Complete'
                                          : '${total.toInt() + 30} % COMPLETE',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    username ?? '',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  if (aboutme != null &&
                                      languages != null &&
                                      Pets != null &&
                                      Drinking != null &&
                                      Smoking != null &&
                                      Diets != null &&
                                      job != null &&
                                      education != null &&
                                      relationType != null &&
                                      relationshipgoals != null)
                                    Image.asset(
                                      'assets/icons/verify.png',
                                      height: 24.h,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(right: 20, left: 20, top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  height: 100.h,
                                  width: 100.w,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset('assets/star_icon.svg',
                                          height: 30),
                                      SizedBox(height: 20.h),
                                      const Text('0 Super Likes',
                                          textAlign: TextAlign.center),
                                      const Text('GET MORE',
                                          style: TextStyle(color: Colors.blue),
                                          textAlign: TextAlign.center)
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 100.h,
                                  width: 100.w,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        'assets/thunder_icon.svg',
                                        height: 30.h,
                                      ),
                                      SizedBox(height: 20.h),
                                      const Text('My Boosts',
                                          textAlign: TextAlign.center),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 100.h,
                                  width: 100.w,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12))),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/explore_active_icon.svg',
                                          height: 30.h),
                                      SizedBox(height: 20.h),
                                      const Text('Subscription',
                                          textAlign: TextAlign.center),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              'About Me',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                            Container(
                              height: 100.h,
                              width: MediaQuery.of(context).size.width.w,
                              margin: const EdgeInsets.only(top: 12),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text(
                                  aboutme == null
                                      ? "None" // if relationshipgoals is null, show "None"
                                      : aboutme,
                                  maxLines: 5,
                                  style: TextStyle(
                                      fontSize: 16.sp, color: Colors.grey),
                                ),
                              ),
                            ),
                            SizedBox(height: 20.h),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              child: Text(
                                'Interest',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                ),
                              ),
                            ),
                            GridView.count(
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 3,
                              childAspectRatio: 2.5,
                              shrinkWrap: true,
                              children: List.generate(
                                interestsss.length,
                                (index) {
                                  final interest = interestsss[index];
                                  final isSelected =
                                      saveinterests.contains(interest);
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: InterestSelection(
                                      text: interest,
                                      isSelected: isSelected,
                                      onTap: () {
                                        // handle interest s`election
                                      },
                                      Iconn: icons[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Relationship Goals',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                            Container(
                              height: 50.h,
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.only(top: 12),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.remove_red_eye_sharp),
                                      SizedBox(width: 10.w),
                                      const Text("Looking for"),
                                      const Spacer(),
                                      Image.asset(
                                        'assets/icons/party.png',
                                        height: 16.h,
                                      ),
                                      Text(
                                        relationshipgoals == null
                                            ? "None" // if relationshipgoals is null, show "None"
                                            : relationshipgoals, // else show the value stored in shared preferences
                                        style: const TextStyle(
                                            color: Colors.black),
                                      )
                                    ],
                                  )),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Relationship Type',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                            Container(
                              height: 50.h,
                              width: MediaQuery.of(context).size.width.w,
                              margin: const EdgeInsets.only(top: 12),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.remove_red_eye_sharp),
                                      SizedBox(width: 10.w),
                                      const Text("Open to"),
                                      const Spacer(),
                                      Text(
                                        relationType == null
                                            ? "None" // if relationshipgoals is null, show "None"
                                            : relationType,
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Languages I know',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                            Container(
                              height: 50.h,
                              width: MediaQuery.of(context).size.width.w,
                              margin: const EdgeInsets.only(top: 12),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.language_sharp),
                                      SizedBox(width: 10.w),
                                      const Text("Languages"),
                                      SizedBox(width: 50.w),
                                      Flexible(
                                          child: Text(
                                        languages == null
                                            ? "None" // if relationshipgoals is null, show "None"
                                            : languages,
                                        overflow: TextOverflow.ellipsis,
                                      )),
                                    ],
                                  )),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Lifestyle',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width.w,
                              margin: const EdgeInsets.only(top: 12),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.pets),
                                          SizedBox(width: 10.w),
                                          const Text("Pets"),
                                          const Spacer(),
                                          Text(
                                            Pets == null
                                                ? "None" // if relationshipgoals is null, show "None"
                                                : Pets,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 2, thickness: 2),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12, top: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.wine_bar),
                                          SizedBox(width: 10.w),
                                          const Text("Drinking"),
                                          const Spacer(),
                                          Text(
                                            Drinking == null
                                                ? "None" // if relationshipgoals is null, show "None"
                                                : Drinking,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 2, thickness: 2),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12, top: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(
                                              Icons.smoking_rooms_outlined),
                                          SizedBox(width: 10.w),
                                          const Text("Smoking"),
                                          const Spacer(),
                                          Text(
                                            Smoking == null
                                                ? "None" // if relationshipgoals is null, show "None"
                                                : Smoking,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 2, thickness: 2),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 12, top: 12),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.fastfood_rounded),
                                          SizedBox(width: 10.w),
                                          const Text("Diet preferences"),
                                          const Spacer(),
                                          Text(
                                            Diets == null
                                                ? "None" // if relationshipgoals is null, show "None"
                                                : Diets,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Job Title',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                            Container(
                              height: 50.h,
                              width: MediaQuery.of(context).size.width.w,
                              margin: const EdgeInsets.only(top: 12),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.work_outlined),
                                      SizedBox(width: 10.w),
                                      const Text("Job "),
                                      const Spacer(),
                                      const Icon(Icons.work_outline),
                                      Text(
                                        job ?? "None",
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Company',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                            Container(
                              height: 50.h,
                              width: MediaQuery.of(context).size.width.w,
                              margin: const EdgeInsets.only(top: 12),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.local_post_office),
                                      SizedBox(width: 5.w),
                                      const Text("Company Name"),
                                      const Spacer(),
                                      const Icon(Icons.work_history),
                                      Text(
                                        company == null
                                            ? "None" // if relationshipgoals is null, show "None"
                                            : company,
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              'Education',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                            Container(
                              height: 50.h,
                              width: MediaQuery.of(context).size.width.w,
                              margin: const EdgeInsets.only(top: 12),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(Icons.school),
                                      SizedBox(width: 10.w),
                                      const Text("University Name "),
                                      const Spacer(),
                                      const Icon(Icons.school_outlined),
                                      Text(
                                        education == null
                                            ? "None" // if relationshipgoals is null, show "None"
                                            : education,
                                      ),
                                    ],
                                  )),
                            ),
                            SizedBox(
                              height: 20.h,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

   getUserLocation() async {
    // Check if location service is enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location service is not enabled, handle accordingly
      return;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Location permission is not granted, handle accordingly
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Location permissions are permanently denied, handle accordingly
      return;
    }
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    // Extract sub-street and street information
    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      // Initialize Firebase
      final firebaseAuth = FirebaseAuth.instance;
      final firebaseUser = firebaseAuth.currentUser;
      final userId = firebaseUser!.uid;
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
      userRef.set({
        'Address':
            '${placemark.locality},${placemark.subLocality},${placemark.administrativeArea},${placemark.subAdministrativeArea},${placemark.country},${placemark.street},${placemark.thoroughfare}' ??
                '',
        'Latitude': position.latitude,
        'Longitude': position.longitude,
      }, SetOptions(merge: true));
    }
    return placemarks;
  }
}
