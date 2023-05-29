import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashed_circle/dashed_circle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:share_plus/share_plus.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/widgets/story_view.dart';
import 'package:tinderapp/Screens/storiesssss/stories_editor.dart';

class StoryScreenUI extends StatefulWidget {
  const StoryScreenUI({Key? key}) : super(key: key);

  @override
  State<StoryScreenUI> createState() => _StoryScreenUIState();
}

class _StoryScreenUIState extends State<StoryScreenUI>
    with TickerProviderStateMixin {
  late Animation<double> gap;
  late Animation<double> base;
  late Animation<double> reverse;
  late AnimationController controller;
  final tooltipController = JustTheController();
  List<String> existingImages = [];
  final firebaseAuth = FirebaseAuth.instance;
  late String currentUserId;
  late List<User> users;

  Future<void> _handleAddStatus() async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final firebaseUser = FirebaseAuth.instance.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentSnapshot userSnapshot = await users.doc(userId).get();
    List<String> existingImages = [];

    if (userSnapshot.exists) {
      final data = userSnapshot.data();
      if (data != null &&
          data is Map<String, dynamic> &&
          data.containsKey('Story`s')) {
        existingImages = List<String>.from(data['Story`s']);
      }
    }

    if (existingImages.isEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoriesEditor(
            giphyKey: 'WKuztU42J2ebmENA9aa43yfnrqjg3G5f',
            galleryThumbnailQuality: 300,
            onDone: (uri) {
              debugPrint(uri);
              Share.shareFiles([uri]);
            },
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MoreStories(img: existingImages),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final firebaseUser = firebaseAuth.currentUser;
    currentUserId = firebaseUser!.uid;
    users = [];
    Future.delayed(const Duration(seconds: 2), () {
      tooltipController.showTooltip(immediately: true);
    });
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    base = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    reverse = Tween<double>(begin: 0.0, end: -5.0).animate(base);
    gap = Tween<double>(begin: 15.0, end: 0.0).animate(reverse);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = firebaseAuth.currentUser!;
    final userId = firebaseUser.uid;
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
          final List<String>? images = data!['images']?.cast<String>();
          final String? firstImage =
              images != null && images.isNotEmpty ? images[0] : null;
          return SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Column(
                        children: [
                          JustTheTooltip(
                            controller: tooltipController,
                            backgroundColor: Colors.purpleAccent.shade100,
                            content: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Once you have added the story, you have to long-press on it to add more stories.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            child: RotationTransition(
                              turns: base,
                              child: DashedCircle(
                                gapSize: gap.value,
                                dashes: 20,
                                color: Theme.of(context).primaryColor,
                                child: RotationTransition(
                                  turns: reverse,
                                  child: GestureDetector(
                                    onTap: _handleAddStatus,
                                    onLongPress: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StoriesEditor(
                                            giphyKey:
                                                'WKuztU42J2ebmENA9aa43yfnrqjg3G5f',
                                            galleryThumbnailQuality: 300,
                                            onDone: (uri) {
                                              debugPrint(uri);
                                              Share.shareFiles([uri]);
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(firstImage!),
                                        backgroundColor: Colors.pinkAccent,
                                        radius: 26,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            "Add Status",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final docs = snapshot.data!.docs;
                        users = docs
                            .where((doc) => doc.id != currentUserId)
                            .map(
                              (doc) => User(
                                id: doc.id,
                                username: (doc.data()
                                        as Map<String, dynamic>)['username'] ??
                                    '',
                                stories: List<String>.from((doc.data()
                                        as Map<String, dynamic>)['Story`s'] ??
                                    []),
                                images: List<String>.from((doc.data()
                                        as Map<String, dynamic>)['images'] ??
                                    []),
                              ),
                            )
                            .toList();

                        return SizedBox(
                          height: 100,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return user.stories.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    MoreStories(
                                                        img: user.stories),
                                              ),
                                            ),
                                            child: RotationTransition(
                                              turns: base,
                                              child: DashedCircle(
                                                gapSize: gap.value,
                                                dashes: 20,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                child: RotationTransition(
                                                  turns: reverse,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        user.images[index],
                                                      ),
                                                      radius: 26,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            user.username,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const Text('');
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class MoreStories extends StatefulWidget {
  final List img;

  const MoreStories({super.key, required this.img});
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();
  int i = 0;
  List<StoryItem> l = [];
  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.img.length; i++) {
      l.add(StoryItem.pageImage(
        url: widget.img[i],
        controller: storyController,
      ));
    }
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StoryView(
        onVerticalSwipeComplete: (p0) {
          return Navigator.pop(context);
        },
        storyItems: l,
        onStoryShow: (s) {
          if (kDebugMode) {
            print("Showing a story");
          }
        },
        onComplete: () {
          if (kDebugMode) {
            print("Completed a cycle");
          }
          i++;
          setState(() {});
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}

class User {
  String id;
  String username;
  List<String> stories;
  List<String> images;

  User(
      {required this.id,
      required this.username,
      required this.stories,
      required this.images});
}
