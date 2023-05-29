import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:lottie/lottie.dart';
import 'package:tinderapp/Screens/profile_card.dart';
import '../const.dart';
import '../data/explore_json.dart';
import '../data/icons.dart';
import '../widgets/filters_home_page.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

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
  List<int> _swipedIndices = [];
  int? previousIndex;
  @override
  void initState() {
    super.initState();
    final firebaseUser = firebaseAuth.currentUser;
    currentUserId = firebaseUser!.uid;

    users = [];
    setState(() {
      itemsTemp = explore_json;
      itemLength = explore_json.length;
    });
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

  void _scaleDialog() {
    showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a1, a2) {
        return Container();
      },
      transitionBuilder: (ctx, a1, a2, child) {
        var curve = Curves.easeInOut.transform(a1.value);
        return Transform.scale(
          scale: curve,
          child: Lottie.asset('assets/lottie/match.json'),
        );
      },
      transitionDuration: const Duration(seconds: 3),
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

  Widget getBody() {
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
                  ))
              .toList();
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
                              width: 1, color: Colors.grey.withOpacity(0.7)),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              enableDrag: true,
                              useSafeArea: true,
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
                        _swipedIndices.removeLast();
                      } else if (align.x > 0.5) {
                        showRightLabel();
                        _swipedIndices.removeLast();
                      } else {
                        setState(() {
                          labelVisible = false;
                        });
                      }
                    },
                       swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
                labelVisible = false;
                if (index == (itemsTemp.length - 1)) {
                setState(() {
                itemLength = itemsTemp.length - 1;
                });
                }
                _swipedIndices.add(index);

                final cardData = users[index];
                final myUserId = firebaseAuth.currentUser!.uid;
                final myUserRef = FirebaseFirestore.instance.collection('users').doc(myUserId);
                final yourUserId = users[index % users.length].id;
                final yourUserRef = FirebaseFirestore.instance.collection('users').doc(yourUserId);

                if (orientation == CardSwipeOrientation.LEFT) {
                // Save card in 'dislikes' field
                myUserRef.update({
                'dislikes': FieldValue.arrayUnion([cardData.id]),
                });
                } else if (orientation == CardSwipeOrientation.RIGHT) {
                // Save card in 'likes' field
                myUserRef.update({
                'likes': FieldValue.arrayUnion([cardData.id]),
                }).then((_) {
                // Check if the other user also liked my card
                yourUserRef.get().then((yourUserDoc) {
                final yourUserLikes = List<String>.from(
                yourUserDoc.data()!['likes'] ?? [],
                );
                if (yourUserLikes.contains(cardData.id)) {
                // Both users liked each other, it's a match!
                final matchId = generateMatchId(myUserId, yourUserId);

                // Save the match in Firebase
                FirebaseFirestore.instance.collection('matches').doc(matchId).set({
                'user1': myUserId,
                'user2': yourUserId,
                'timestamp': FieldValue.serverTimestamp(),
                }).then((_) {
                // Show the match image or perform any other action
                // You can use a Snack-bar or Dialog to show the match
                _scaleDialog();
                }).catchError((error) {
                if (kDebugMode) {
                print('Failed to save match: $error');
                }
                });
                }
                }).catchError((error) {
                if (kDebugMode) {
                print('Failed to fetch your user\'s data: $error');
                }
                });
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
                                  index < users.length
                                      ? SizedBox(
                                          width: size.width.w,
                                          height: size.height * 0.8.h,
                                          child: Image.network(user.images[0],
                                              fit: BoxFit.cover))
                                      : Container(
                                          width: size.width,
                                          height: size.height,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    itemsTemp[index]['img']),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
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
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                                          index < users.length
                                                              ? user.username
                                                              : itemsTemp[index]
                                                                  ['name'],
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
                                                                  color: green,
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
                                                          if (indexLikes == 0) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 8),
                                                              child: Container(
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
                                                          }
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 8),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                  color: white
                                                                      .withOpacity(
                                                                          0.2)),
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
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
                                                            builder: (context) {
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
                                                                      : itemsTemp[
                                                                              index]
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
                                        left:
                                            MediaQuery.of(context).size.width *
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
  String id;
  String username;
  List<String> images;

  User({required this.id, required this.username, required this.images});
}
