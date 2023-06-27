import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:geodesy/geodesy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinderapp/Screens/profile_card.dart';
import 'package:tinderapp/const.dart';
import 'package:tinderapp/data/explore_json.dart';
import 'package:tinderapp/data/icons.dart';
import 'package:tinderapp/widgets/filters_home_page.dart';
import 'navigationbar.dart';
import 'dart:ui' as ui;

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with TickerProviderStateMixin {
  CardController controller = CardController();
  final firebaseAuth = FirebaseAuth.instance;
  late final String currentUserId;
  late List<User> users = [];
  List itemsTemp = [];
  int itemLength = 0;
  bool labelVisible = false;
  List label = [];
  String? labelType;
  int currentIndex = 0; // Current index of the card
  List<int> swipedIndices = [];
  List<int> _swipedIndices = [];
  Position? _currentPosition;
  int? previousIndex;
  AnimationController? _animationController;
  late SharedPreferences sharedPreferences;
  @override
  void initState() {
    final firebaseUser = firebaseAuth.currentUser;
    currentUserId = firebaseUser!.uid;
    _getCurrentLocation();
    users = [];
    setState(() {
      itemsTemp = explore_json;
      itemLength = explore_json.length;
    });
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    restoreLastSwipedIndex();
    super.initState();
  }

  Future<void> restoreLastSwipedIndex() async {
    final prefs = await SharedPreferences.getInstance();
    final restoredIndex = prefs.getInt('lastSwipedIndex') ?? 0;
    setState(() {
      currentIndex = restoredIndex;
    });
  }

  Future<void> saveSwipedCardIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    swipedIndices.add(index);
    await prefs.setInt('lastSwipedIndex', index);
  }

  void showLeftLabel() {
    setState(() {
      labelVisible = true;
      labelType = 'like';
    });
  }

  void showRightLabel() {
    setState(() {
      labelVisible = true;
      labelType = 'dislike';
    });
  }

  void showUpLabel() {
    setState(() {
      labelVisible = true;
      labelType = 'super like';
    });
  }

  String generateMatchId(String userId1, String userId2) {
    final sortedUserIds = [userId1, userId2]..sort();
    return '${sortedUserIds[0]}_${sortedUserIds[1]}';
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _playAnimation() {
    if (_animationController!.isCompleted) {
      _animationController!.reverse();
    } else {
      _animationController!.forward();
    }
  }

  void _scaleDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext ctx, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return Container(); // Replace this with your desired page widget
      },
      transitionBuilder: (BuildContext ctx, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        var curve = Curves.easeInOut.transform(animation.value);
        return Transform.scale(
          scale: curve,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Lottie.asset('assets/lottie/match.json'),
                GestureDetector(
                  onTap: () {
                    _playAnimation();
                    Future.delayed(const Duration(seconds: 1), () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MyNavigationBar(
                          i: 2,
                        );
                      }));
                    });
                  },
                  child: Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.5,
                      color: Colors.black12,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Woah!! You Got a \nmatch You want\n to Text him/her ..?',
                              style: TextStyle(
                                  foreground: Paint()
                                    ..shader = ui.Gradient.linear(
                                      const Offset(0, 60),
                                      const Offset(150, 20),
                                      <Color>[
                                        Colors.lightBlueAccent,
                                        Colors.redAccent,
                                      ],
                                    ),
                                  // fontWeight: FontWeight.bold,
                                  fontFamily: 'Times New Roman',
                                  fontSize: 18),
                              textAlign: TextAlign.center),
                          Lottie.asset(
                            'assets/lottie/send.json',
                            height: 100, // Replace with your animation file
                            controller: _animationController,
                            animate: false,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionDuration: const Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(child: getBody()),
      bottomSheet: getBottomSheet(),
    );
  }

  getBody() {
    var size = MediaQuery.of(context).size;
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
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final docs = snapshot.data!.docs;

          users = docs
              .where((doc) => doc.id != currentUserId)
              .map((doc) => User(
                    id: doc.id,
                    username:
                        (doc.data() as Map<String, dynamic>)['username'] ?? '',
                    images: List<String>.from(
                        (doc.data() as Map<String, dynamic>)['images'] ?? []),
                    latitude:
                        (doc.data() as Map<String, dynamic>)['Latitude'] ?? 0.0,
                    longitude:
                        (doc.data() as Map<String, dynamic>)['Longitude'] ??
                            0.0,
                  ))
              .where((user) {
            if (user.latitude != null && user.longitude != null) {
              final userLocation = LatLng(user.latitude, user.longitude);
              final distance = Geodesy().distanceBetweenTwoGeoPoints(
                LatLng(_currentPosition?.latitude, _currentPosition?.longitude),
                userLocation,
              );
              // Change the radius value as needed
              const double radius = 10.0; // in kilometers
              return distance <= radius * 1000; // convert radius to meters
            } else {
              docs.where((doc) => doc.id != currentUserId).map((doc) => User(
                    id: doc.id,
                    username:
                        (doc.data() as Map<String, dynamic>)['userna me'] ?? '',
                    images: List<String>.from(
                        (doc.data() as Map<String, dynamic>)['images'] ?? []),
                  ));
            }
            return false;
          }).toList();

          // Perform any other actions with the filtered users

          final firebaseAuth = FirebaseAuth.instance;
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 50,
            ),
            child: Stack(
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Discover",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 28.sp),
                      ),
                      Container(
                        height: 50.h,
                        width: 50.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.withOpacity(0.7),
                          ),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              enableDrag: true,
                              context: context,
                              builder: (context) {
                                return const Filters();
                              },
                            );
                          },
                          child: const Icon(
                              Icons.settings_input_component_rounded,
                              size: 18,
                              color: Colors.pinkAccent),
                        ),
                      ),
                    ],
                  ),
                ),
                if (users.isNotEmpty)
                  SizedBox(
                    height: size.height,
                    child: TinderSwapCard(
                      totalNum: itemLength,
                      cardController: controller = CardController(),
                      swipeUpdateCallback:
                          (DragUpdateDetails details, Alignment align) {
                        if (align.y < -0.5) {
                          showUpLabel();
                          // labelVisible = false;
                        } else if (align.x < -0.5) {
                          showLeftLabel();
                        } else if (align.x > 0.5) {
                          showRightLabel();
                        } else {
                          setState(() {
                            labelVisible = false;
                          });
                        }
                      },
                      swipeCompleteCallback:
                          (CardSwipeOrientation orientation, int index) async {
                        labelVisible = false;
                        if (index == (itemsTemp.length - 1)) {
                          setState(() {
                            itemLength = itemsTemp.length - 1;
                            itemLength = users.length;
                          });
                        }
                        _swipedIndices.add(index);
                        saveSwipedCardIndex(index);
                        setState(() {
                          currentIndex = index; // Update the currentIndex
                        });
                        final cardData = users[index];
                        final myUserId = firebaseAuth.currentUser!.uid;
                        final myUserRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc(myUserId);
                        final yourUserId = users[index % users.length].id;
                        final yourUserRef = FirebaseFirestore.instance
                            .collection('users')
                            .doc(yourUserId);
                        if (orientation == CardSwipeOrientation.LEFT) {
                          // Save card in 'dislikes' field
                          myUserRef.update({
                            'dislikes': FieldValue.arrayUnion([cardData.id]),
                          });
                        } else if (orientation == CardSwipeOrientation.RIGHT) {
                          // Save card in 'likes' field
                          myUserRef.update({
                            'My Likes': FieldValue.arrayUnion([cardData.id]),
                          });
                          yourUserRef.update({
                            'other Likes': FieldValue.arrayUnion([myUserId]),
                          });
                          // Check if the other user also liked my card
                          yourUserRef.get().then((yourUserDoc) {
                            final yourUserLikes = List<String>.from(
                                yourUserDoc.data()!['My Likes']);
                            if (yourUserLikes.contains(myUserId)) {
                              // Save the match in Firebase
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(myUserId)
                                  .update({
                                'Match_with':
                                    FieldValue.arrayUnion([yourUserId])
                              });
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(yourUserId)
                                  .update({
                                'Match_with': FieldValue.arrayUnion([myUserId])
                              }).then((_) {
                                // Show the match image or perform any other action
                                // You can use a Snack-bar or Dialog to show the match
                                _scaleDialog(context);
                              }).catchError((error) {
                                if (kDebugMode) {
                                  print('Failed to save match: $error');
                                }
                              });
                            }
                          }).catchError((error) {
                            if (kDebugMode) {
                              print(
                                  'Failed to fetch your user\'s data: $error');
                            }
                          }).catchError((error) {
                            if (kDebugMode) {
                              print('Failed to save like: $error');
                            }
                          });
                        } else if (orientation == CardSwipeOrientation.UP) {
                          // Save card in 'super-likes' field
                          myUserRef.update({
                            'super-likes': FieldValue.arrayUnion([cardData.id]),
                          });
                        }
                      },
                      maxWidth: MediaQuery.of(context).size.width,
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                      minWidth: MediaQuery.of(context).size.width * 0.75,
                      minHeight: MediaQuery.of(context).size.height * 0.4,
                      cardBuilder: (context, index) {
                        final user = users[index % users.length];
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: grey.withOpacity(0.3),
                                      blurRadius: 5,
                                      spreadRadius: 2),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    SizedBox(
                                        width: size.width.w,
                                        height: size.height * 0.8.h,
                                        child: Image.network(user.images[0],
                                            fit: BoxFit.cover)),
                                    Container(
                                      width: size.width,
                                      height: size.height,
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                            black.withOpacity(0.25),
                                            black.withOpacity(0),
                                          ],
                                              end: Alignment.topCenter,
                                              begin: Alignment.bottomCenter)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: size.width * 0.70,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            user.username,
                                                            style: const TextStyle(
                                                                color: white,
                                                                fontSize: 24,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          Text(
                                                            itemsTemp[index]
                                                                ['age'],
                                                            style:
                                                                const TextStyle(
                                                              color: white,
                                                              fontSize: 22,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 10,
                                                            height: 10,
                                                            decoration:
                                                                const BoxDecoration(
                                                                    color:
                                                                        green,
                                                                    shape: BoxShape
                                                                        .circle),
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          const Text(
                                                            "Recently Active",
                                                            style: TextStyle(
                                                              color: white,
                                                              fontSize: 16,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 15,
                                                      ),
                                                      Row(
                                                        children: List.generate(
                                                          itemsTemp[index]
                                                                  ['likes']
                                                              .length,
                                                          (indexLikes) {
                                                            if (indexLikes ==
                                                                0) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        right:
                                                                            8),
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                              white,
                                                                          width:
                                                                              2),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                      color: white
                                                                          .withOpacity(
                                                                              0.4)),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 3,
                                                                        bottom:
                                                                            3,
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            10),
                                                                    child: Text(
                                                                      itemsTemp[index]
                                                                              [
                                                                              'likes']
                                                                          [
                                                                          indexLikes],
                                                                      style: const TextStyle(
                                                                          color:
                                                                              white),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 8),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                    color: white
                                                                        .withOpacity(
                                                                            0.2)),
                                                                child: Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 3,
                                                                      bottom: 3,
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                                  child: Text(
                                                                    itemsTemp[index]
                                                                            [
                                                                            'likes']
                                                                        [
                                                                        indexLikes],
                                                                    style: const TextStyle(
                                                                        color:
                                                                            white),
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Expanded(
                                                  child: SizedBox(
                                                    width: size.width * 0.2,
                                                    child: Center(
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) {
                                                                return CardDetails(
                                                                    profile: index <
                                                                            users
                                                                                .length
                                                                        ? user
                                                                            .username
                                                                        : itemsTemp[index]
                                                                            [
                                                                            'name'],
                                                                    pic: index <
                                                                            users
                                                                                .length
                                                                        ? user.images[
                                                                            0]
                                                                        : itemsTemp[index]
                                                                            [
                                                                            'img']);
                                                              },
                                                            ),
                                                          );
                                                        },
                                                        child: const Icon(
                                                          Icons.info,
                                                          color: white,
                                                          size: 28,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            if (labelVisible)
                              labelType == 'like'
                                  ? Positioned(
                                      top: 10,
                                      left: 10,
                                      child: Image.asset(
                                        'assets/like.png',
                                        height: 100.h,
                                      ),
                                    )
                                  : labelType == 'dislike'
                                      ? Positioned(
                                          top: 10,
                                          right: 10,
                                          child: Image.asset(
                                            'assets/dislike.png',
                                            height: 100.h,
                                          ),
                                        )
                                      : Positioned(
                                          top: 10,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Image.asset(
                                            'assets/superlike.png',
                                            height: 100.h,
                                          ),
                                        ),
                          ],
                        );
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getBottomSheet() {
    var size = MediaQuery.of(context).size;
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user =
        FirebaseFirestore.instance.collection('users').doc(userId);
    return Container(
      width: size.width,
      height: 60.h,
      decoration: const BoxDecoration(color: white),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            item_icons.length,
            (index) {
              return InkWell(
                onTap: () {
                  if (index == 0) {
                    if (_swipedIndices.isNotEmpty) {
                      previousIndex = _swipedIndices.last;
                      _swipedIndices.removeLast();
                      setState(() {
                        itemLength++;
                        // Do something with previousIndex, e.g., display the previous card
                      });
                    }
                  } else if (index == 1) {
                    controller.triggerLeft();
                    showRightLabel();
                    // Save the swiped card in Firestore 'dislikes' field
                    final cardData = itemsTemp[index];
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .update({
                      'dislikes': FieldValue.arrayUnion([cardData['img']]),
                    });
                  } else if (index == 2) {
                    controller.triggerRight();
                    showLeftLabel();
                    // Save the swiped card in Firestore 'likes' field
                    final cardData = itemsTemp[index];
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .update({
                      'likes': FieldValue.arrayUnion([cardData['img']]),
                    });
                  } else if (index == 3) {
                    controller.triggerUp();
                    // Save the swiped card in Firestore 'superlikes' field
                    final cardData = itemsTemp[index];
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .update({
                      'superlikes': FieldValue.arrayUnion([cardData['img']]),
                    });
                  }
                },
                child: Container(
                  width: item_icons[index]['size'],
                  height: item_icons[index]['size'],
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: grey.withOpacity(0.1),
                        spreadRadius: 5,
                        blurRadius: 10,
                        // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      item_icons[index]['icon'],
                      width: item_icons[index]['icon_size'],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class User {
  final String id;
  final String username;
  final List<String> images;
  final double? latitude;
  final double? longitude;

  User({
    required this.id,
    required this.username,
    required this.images,
    this.latitude,
    this.longitude,
  });
}
