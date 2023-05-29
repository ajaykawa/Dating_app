import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tinderapp/Screens/profile_card.dart';
import 'package:tinderapp/Screens/toppicks.dart';

import '../const.dart';
import '../data/likes_json.dart';

class LikesPage extends StatefulWidget {
  const LikesPage({super.key});

  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  final PageController _pageController =
      PageController(initialPage: 0, viewportFraction: 1);
  int pageIndex = 0;
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
      child: Scaffold(
        backgroundColor: white,
        body: PageView(
          controller: _pageController,
          children: [getBody(), const TopPicks()],
        ),
        bottomSheet: getFooter(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[Colors.red, Colors.pinkAccent]),
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  _pageController.animateToPage(--pageIndex,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.linearToEaseOut);
                },
                child: Text(
                  "${likes_json.length} Likes",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              GestureDetector(
                onTap: () {
                  _pageController.animateToPage(++pageIndex,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.linearToEaseOut);
                },
                child: const Text(
                  "Top Picks",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) {
            return CardDetails(
              profile: '',
              pic: '',
            );
          },
        ));
      },
      child: ListView(
        padding: const EdgeInsets.only(bottom: 90),
        children: [
          const Divider(
            thickness: 0.8,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, right: 5),
            child: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: List.generate(
                likes_json.length,
                (index) {
                  return SizedBox(
                    width: (size.width - 15) / 2,
                    height: 250,
                    child: Stack(
                      children: [
                        Container(
                          width: (size.width - 15) / 2,
                          height: 250,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  image: AssetImage((likes_json[index]['img'])),
                                  fit: BoxFit.cover)),
                        ),
                        Container(
                          width: (size.width - 15) / 2,
                          height: 250,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                  colors: [
                                    black.withOpacity(0.25),
                                    black.withOpacity(0),
                                  ],
                                  end: Alignment.topCenter,
                                  begin: Alignment.bottomCenter)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              likes_json[index]['active']
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, bottom: 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                                color: green,
                                                shape: BoxShape.circle),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Text(
                                            "Recently Active",
                                            style: TextStyle(
                                              color: white,
                                              fontSize: 14,
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, bottom: 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                                color: grey,
                                                shape: BoxShape.circle),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Text(
                                            "Offline",
                                            style: TextStyle(
                                              color: white,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFooter() {
    var size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: 90,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Container(
              width: size.width - 70,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient:
                      const LinearGradient(colors: [yellow_one, yellow_two])),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40)),
                          elevation: 16,
                          child: ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              const SizedBox(height: 20),
                              Center(
                                  child: Text(
                                'Get Mingle Gold',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow[800]),
                              )),
                              const SizedBox(height: 20),
                              CircleAvatar(
                                backgroundColor: const Color(0xffBC53FD),
                                radius: 35,
                                child: Image.asset('assets/images/img_10.png',
                                    height: 30),
                              ),
                              const Center(
                                  child: Text(
                                'Unlimited likes',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color: grey,
                                        width: 2,
                                      )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: const [
                                            Text(
                                              '12 \n months',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "\$7/mo",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color: grey,
                                        width: 2,
                                      )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: const [
                                            Text(
                                              '6 \n months',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "\$10/mo",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color: grey,
                                        width: 2,
                                      )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: const [
                                            Text(
                                              '1 \n months',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 16),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "\$19/mo",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w800),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: size.width - 80,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      gradient: const LinearGradient(
                                          colors: [yellow_one, yellow_two])),
                                  child: const Center(
                                    child: Text("CONTINUE",
                                        style: TextStyle(
                                            color: white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Text("SEE WHO LIKES YOU",
                      style: TextStyle(
                          color: white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}