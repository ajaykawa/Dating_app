import 'dart:convert';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_insta/flutter_insta.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinderapp/Screens/login_options.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isSwitched = false;
  var textValue = 'Switch is OFF';
  String instagramId = '';
  FlutterInsta flutterInsta =
      FlutterInsta(); // create instance of FlutterInsta class
  TextEditingController usernameController = TextEditingController();
  final String endpointUrl = 'https://instagram40.p.rapidapi.com/user';
  final String apiKey = '546d08d7d6msh86fe495a5956baep194bbcjsn6c888db13bee';


  Future<String?> _connectInstagramAccount() async {
    const authorizationUrl =
        'https://instagram28.p.rapidapi.com/media_info_v2?short_code=CA_ifcxMjFR';

    try {
      final result = await FlutterWebAuth.authenticate(url: authorizationUrl, callbackUrlScheme: 'https');
      final params = Uri.parse(result).fragment.split('&');
      final token = params.firstWhere((p) => p.startsWith('access_token=')).split('=')[1];
      return token;
    } catch (e) {
     print(">>>>>>>>>>>>>>>>>>>>>>>$e");
      return null;
    }
  }


  Future<String?> _getInstagramUsername(String accessToken) async {
    final response = await http.get(
      Uri.parse('$endpointUrl?access_token=$accessToken'),
      headers: {
        'x-rapidapi-host': 'instagram28.p.rapidapi.com',
        'x-rapidapi-key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['username'];
    } else {
      throw Exception('Failed to retrieve Instagram username');
    }
  }

  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
        textValue = 'Switch Button is ON';
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isSwitched = false;
        textValue = 'Switch Button is OFF';
      });
      print('Switch Button is OFF');
    }
  }

  RangeValues _currentRangeValues = const RangeValues(20, 60);
  int distance = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Settings",
                style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.25.w),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Done",
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SettingOffers(
                      colors: Colors.black,
                      texts: 'Priority Likes, see Who Likes You, and more',
                      img: 'assets/icons/platinum.png',
                    ),
                    const SettingOffers(
                      colors: Colors.orangeAccent,
                      texts: 'See Who Likes You, and more!',
                      img: 'assets/icons/gold-medal.png',
                    ),
                    const SettingOffers(
                      colors: Colors.pink,
                      texts: 'Unlimited likes & more',
                      img: 'assets/icons/add.png',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 100.h,
                          width: MediaQuery.of(context).size.width * 0.45.w,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        blurStyle: BlurStyle.solid)
                                  ],
                                ),
                                height: 50.h,
                                width: 50.w,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                      "assets/thunder_icon.svg",
                                      height: 12),
                                ),
                              ),
                              const Text(
                                "Get Boosts",
                                style: TextStyle(color: Colors.purple),
                              )
                            ],
                          ),
                        ),
                        Container(
                          height: 100.h,
                          width: MediaQuery.of(context).size.width * 0.40.w,
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: Colors.white),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 8,
                                        blurStyle: BlurStyle.solid)
                                  ],
                                ),
                                height: 50.h,
                                width: 50.w,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                      "assets/icons/incognito.png",
                                      color: Colors.black38,
                                      height: 12),
                                ),
                              ),
                              const Text(
                                "Go Incognito",
                                style: TextStyle(color: Colors.black38),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'ACCOUNT SETTINGS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width.w,
                      margin: const EdgeInsets.only(top: 12),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text("Phone Number"),
                                  Spacer(),
                                  Text("+91 ***** *****"),
                                ],
                              ),
                            ),
                            Divider(height: 2.h, thickness: 2),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 12, top: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text("Instagram"),
                                  const Spacer(),
                                  InkWell(
                                    onTap: () async {
                                      if (instagramId.isEmpty) {
                                        final token =
                                            await _connectInstagramAccount();
                                        if (token != null) {
                                          final username =
                                              await _getInstagramUsername(
                                                  token);
                                          setState(() {
                                            instagramId = username!;
                                          });
                                        }
                                      }
                                    },
                                    child: Text(
                                      instagramId.isEmpty
                                          ? "Connect"
                                          : instagramId,
                                      style: TextStyle(
                                        color: instagramId.isEmpty
                                            ? Colors.red
                                            : Colors.black,
                                        fontSize: 15.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 2, thickness: 2),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 8, top: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text("Email"),
                                  Spacer(),
                                  Text("abcd@gmail.com"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child:
                          Text("verify your email to help secure your account"),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(18))),
                      margin: const EdgeInsets.only(top: 12, bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Distance Preference',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18.sp),
                                ),
                                Text(
                                  '${distance}km',
                                  style: TextStyle(
                                    fontSize: 20.0.sp,
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              label: "Distance Preference",
                              activeColor: Colors.red,
                              inactiveColor: Colors.grey,
                              divisions: 12,
                              value: distance.toDouble(),
                              onChanged: (value) {
                                setState(() {
                                  distance = value.toInt();
                                });
                              },
                              min: 5,
                              max: 100,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Only Show People in this range',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18.sp),
                                ),
                                Transform.scale(
                                    scale: 1,
                                    child: Switch(
                                      onChanged: toggleSwitch,
                                      value: isSwitched,
                                      activeColor: Colors.white,
                                      activeTrackColor: Colors.red,
                                      inactiveThumbColor: Colors.white,
                                      inactiveTrackColor: Colors.grey,
                                    )),
                              ],
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Age Prefer',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18.sp),
                                ),
                                Text(
                                  '${_currentRangeValues}',
                                  style: TextStyle(
                                      fontSize: 12.0.sp, color: Colors.grey),
                                ),
                              ],
                            ),
                            RangeSlider(
                              values: _currentRangeValues,
                              inactiveColor: Colors.grey,
                              activeColor: Colors.red,
                              min: 0,
                              max: 100,
                              divisions: 20,
                              labels: RangeLabels(
                                _currentRangeValues.start.round().toString(),
                                _currentRangeValues.end.round().toString(),
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _currentRangeValues = values;
                                });
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  'Only Show People in this range',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18.sp),
                                ),
                                Transform.scale(
                                    scale: 1,
                                    child: Switch(
                                      onChanged: toggleSwitch,
                                      value: isSwitched,
                                      activeColor: Colors.white,
                                      activeTrackColor: Colors.red,
                                      inactiveThumbColor: Colors.white,
                                      inactiveTrackColor: Colors.grey,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove(
                              'userId'); // Remove the user ID from shared preferences
                          // Navigate to the login screen
                          Get.offAll(() => const LoginOptions());
                        },
                        child: Container(
                          height: 40.h,
                          width: 160.w,
                          decoration: const BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                stops: [
                                  0.1,
                                  0.4,
                                  0.6,
                                  0.9,
                                ],
                                colors: [
                                  Colors.pink,
                                  Colors.pinkAccent,
                                  Colors.redAccent,
                                  Colors.red,
                                ],
                              )),
                          child: Center(
                            child: Text('LOG OUT',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ]),
            )));
  }
}
//-----------=============================-------------------------------==================================--------------------------==================-----

class SettingOffers extends StatelessWidget {
  final Color colors;
  final String texts;
  final String img;
  const SettingOffers({

    required this.colors,
    required this.texts,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width.w,
      height: 80.h,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(18))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/explore_active_icon.svg",
              ),
              Text(
                "  tinder ",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.sp),
              ),
              Image.asset(
                img,
                height: 24.h,
              )
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Text(
            texts,
            style: TextStyle(fontSize: 16.sp),
          )
        ],
      ),
    );
  }
}
