import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TopPicks extends StatefulWidget {
  const TopPicks({Key? key}) : super(key: key);

  @override
  State<TopPicks> createState() => _TopPicksState();
}

class _TopPicksState extends State<TopPicks> {
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
        body: Container(
          margin: const EdgeInsets.all(15),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white54,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Play",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp),
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 100.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      // image: DecorationImage(
                      //     image: AssetImage("assets/images/likesbg.jpg"),
                      //     fit: BoxFit.cover,
                      //     opacity: 0.3),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(
                        Icons.lock_clock,
                        color: Colors.white,
                        size: 40,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Crush Time",
                            style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            "You don't have enough likes to play.\n Boost your profile for better \n visibility!",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 12.sp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Explore",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp),
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    LikesContainer(
                      decorateColor: Colors.purpleAccent,
                      // bgimage: 'assets/images/like1.jpg',
                      text: 'Explore the \n Map',
                      icons: Icon(Icons.travel_explore, size: 30),
                    ),
                    LikesContainer(
                      decorateColor: Colors.green,
                      // bgimage: 'assets/images/like2.jpg',
                      text: 'Recent \n Crossings',
                      icons: Icon(Icons.timer, size: 30),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    LikesContainer(
                      decorateColor: Colors.lightBlueAccent,
                      // bgimage: 'assets/images/like3.jpg',
                      text: '1st \n Crossings',
                      icons: Icon(Icons.remove_red_eye_sharp, size: 30),
                    ),
                    LikesContainer(
                      decorateColor: Colors.blueGrey,
                      // bgimage: 'assets/images/like4.jpg',
                      text: 'Repeat \n Crossings',
                      icons: Icon(Icons.bolt, size: 30),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Text(
                  "Meet",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp),
                ),
                SizedBox(height: 10.h),
                Text(
                  "A happener for",
                  style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 20.sp),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  height: 200.h,
                  width: MediaQuery.of(context).size.width.w,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      CarouselSlider(
                        items: const [
                          SlidingContainers(
                            // image: 'assets/images/normal.jpg',
                            text: " You'll know when \n you find it",
                          ),
                          SlidingContainers(
                            // image: 'assets/images/serious.jpg',
                            text:
                                " If you are looking for \n something serious",
                          ),
                          SlidingContainers(
                            // image: 'assets/images/benefits.jpg',
                            text: " If you prefer no strings \n attached",
                          ),
                        ],
                        //Slider Container properties
                        options: CarouselOptions(
                          height: 180.0.h,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          // autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "A Traveller",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 200.h,
                  width: MediaQuery.of(context).size.width.w,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      CarouselSlider(
                        items: const [
                          SlidingContainers(
                            // image: 'assets/images/hikingcouple.jpg',
                            text: "Hiking & backpack",
                          ),
                          SlidingContainers(
                            // image: 'assets/images/museumcouple.jpg',
                            text: " Museum & postcards",
                          ),
                          SlidingContainers(
                            // image: 'assets/images/beachcouple.jpg',
                            text: "Deckchair & sunscreen",
                          ),
                        ],
                        //Slider Container properties
                        options: CarouselOptions(
                          height: 180.0.h,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          // autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "A chef(or almost...)",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 200.h,
                  width: MediaQuery.of(context).size.width.w,
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      CarouselSlider(
                        items: const [
                          SlidingContainers(
                            // image: 'assets/images/chef1.jpg',
                            text: "I know a few good \n recipes",
                          ),
                          SlidingContainers(
                            // image: 'assets/images/chef2.jpg',
                            text: "Gourmet - For a three course \n meal",
                          ),
                          SlidingContainers(
                            // image: 'assets/images/chef3.jpg',
                            text: "I'm an excellent chef",
                          ),
                          SlidingContainers(
                            // image: 'assets/images/chef1.jpg',
                            text: "For a meal without \n leaving a couch",
                          ),
                          SlidingContainers(
                            // image: 'assets/images/chef2.jpg',
                            text: " Purely Vegan, Only in plant base meals",
                          ),
                          SlidingContainers(
                            // image: 'assets/images/chef3.jpg',
                            text: "Flexiterian - Meal with or\n without meat.",
                          ),
                        ],
                        //Slider Container properties
                        options: CarouselOptions(
                          height: 180.0.h,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 1 / 1,
                          // autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "A Partner",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 30.sp),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  height: 200.h,
                  width: MediaQuery.of(context).size.width,
                  child: ListView(
                    children: [
                      CarouselSlider(
                        items: const [
                          SlidingContainers(
                            // image: 'assets/images/coupleparty.jpg',
                            text: "To party with \n some nightmare adventures",
                          ),
                          SlidingContainers(
                            // image: 'assets/images/couplegym.jpg',
                            text: "To exercise with some intense sessions",
                          ),
                        ],
                        //Slider Container properties
                        options: CarouselOptions(
                          height: 180.0.h,
                          enlargeCenterPage: true,
                          autoPlay: true,
                          aspectRatio: 16 / 9,
                          // autoPlayCurve: Curves.fastOutSlowIn,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50.h,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------------------------------------------------------

class SlidingContainers extends StatelessWidget {
  // final String image;
  final String text;
  const SlidingContainers({
    // required this.image,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        // image: DecorationImage(
        //   image: AssetImage(image),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.black.withOpacity(0.5),
          ),
          height: 50.h,
          width: MediaQuery.of(context).size.width,
          child: Center(
              child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ))),
    );
  }
}

//-------------------------------------------------------------------------------------------------------------------------------

class LikesContainer extends StatelessWidget {
  final Color decorateColor;
  // final String bgimage;
  final Widget icons;
  final String text;
  const LikesContainer({
    required this.decorateColor,
    // required this.bgimage,
    required this.text,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2.h,
      width: MediaQuery.of(context).size.width * 0.4.w,
      decoration: BoxDecoration(
          color: decorateColor,
          // image: DecorationImage(
          //     image: AssetImage(bgimage), fit: BoxFit.cover, opacity: 0.2),
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              height: 50.h,
              width: 50.w,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: icons,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(text,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp)),
          ),
        ],
      ),
    );
  }
}
