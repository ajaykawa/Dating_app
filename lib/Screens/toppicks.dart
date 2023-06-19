import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:tinderapp/Screens/profile_card.dart';

import 'package:flutter/material.dart';

class TopPicks extends StatefulWidget {
  const TopPicks({Key? key}) : super(key: key);

  @override
  State<TopPicks> createState() => _TopPicksState();
}

class _TopPicksState extends State<TopPicks> {
  List<Map<String, dynamic>> matchingUsers = [];

  @override
  Widget build(BuildContext context) {
    Future<bool> showExitPopup() async {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Exit App'),
              content: const Text('Do you want to exit the App?'),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.purple),
                  onPressed: () => Navigator.of(context).pop(false),
                  // Return false when "NO" is clicked.
                  child: const Text('No'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.purple),
                  onPressed: () => SystemNavigator.pop(),
                  // Return true when "YES" is clicked.
                  child: const Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('interests')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lottie/notfound.json',
                        height: MediaQuery.of(context).size.height * 0.2),
                    const Text(
                      'Loading......',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Times New Roman',
                      ),
                    ),
                  ],
                ),
              );
            }

            var currentUserInterests = <String>[];
            for (var doc in snapshot.data!.docs) {
              currentUserInterests.add(doc.id);
            }

            return StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/lottie/notfound.json',
                            height: MediaQuery.of(context).size.height * 0.2),
                        const Text(
                          'Loading......',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                      ],
                    ),
                  );
                }
                matchingUsers.clear(); // Clear the previous matching users

                snapshot.data!.docs.forEach((userDoc) {
                  var userData = userDoc.data() as Map<String, dynamic>;
                  var userInterests = userData['Interests'] as List<dynamic>;

                  // Check if the user's interests intersect with yours
                  var commonInterests = userInterests
                      .toSet()
                      .intersection(userInterests.toSet())
                      .toList();
                  if (commonInterests.isNotEmpty) {
                    // Modify the condition as per your requirement (2 or 3 common interests)
                    matchingUsers.add(userData);
                  }
                });

                if (matchingUsers.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/lottie/notfound.json',
                            height: MediaQuery.of(context).size.height * 0.2),
                        const Text(
                          'No matching interests',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Times New Roman',
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return GridView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    var userData = matchingUsers[index];
                    var imageUrl = userData['images'] as List<dynamic>;
                    var name = userData['username'] as String;

                    return Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return const Gold();
                              //   CardDetails(
                              //   profile: name,
                              //   pic: imageUrl[0] ?? '',
                              // );
                            }),
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height*0.6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(imageUrl[0] ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    bottom: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        name ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class Gold extends StatefulWidget {
  const Gold({Key? key}) : super(key: key);

  @override
  State<Gold> createState() => _GoldState();
}

class _GoldState extends State<Gold> {
  int selectedPlanIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              stops: const [0.2, 0.3, 0.4, 0.9],
              colors: [
                Colors.yellow[200]!,
                Colors.yellow[100]!,
                Colors.yellow[100]!,
                Colors.yellow[300]!,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      InkWell(
                          onTap: () {
                            return Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.close,
                          )),
                      const SizedBox(width: 100),
                      SvgPicture.asset(
                        "assets/explore_active_icon.svg",
                        color: Colors.orange,
                      ),
                      const Text(
                        "  tinder ",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 28),
                      ),
                      Image.asset(
                        'assets/icons/gold-medal.png',
                        height: 24,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Swipe on the best profiles every day",
                    style: TextStyle(
                        fontFamily: 'sans-serif-condensed',
                        fontWeight: FontWeight.bold,
                        fontSize: 32),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Select a plan",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'sans-serif-condensed',
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      itemCount: 3,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        bool isSelected = index == selectedPlanIndex;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedPlanIndex = index;
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            height: 200,
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 3),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(30))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${mnt[index]} month",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'sans-serif',
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "₹ ${rs[index]}/month",
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.orange
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: ListView.builder(
                      physics: const  NeverScrollableScrollPhysics(),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            const Icon(Icons.done, size: 45),
                            Text(
                              offr[index],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: 'Times New Roman'),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 50,
                    margin: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Continue - ₹ ${rs[selectedPlanIndex]}", // Display selected amount
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

List<String> mnt = ['1', '6', '12'];
List<String> rs = ['589.00', '366.50', '274.92'];
List<String> offr = [
  "Unlimited likes",
  "See Who Likes you",
  "Unlimited Rewards",
  "1 Free Boosts per month",
  "5 Free Super likes per week",
  "Hide ads"
];
