import 'package:flutter/material.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import '../data/explore_json.dart';

class CardDetails extends StatefulWidget {
  final String profile;
  final String pic;
  const CardDetails({Key? key, required this.profile, required this.pic})
      : super(key: key);

  @override
  State<CardDetails> createState() => _CardDetailsState();
}

class _CardDetailsState extends State<CardDetails> {
  CardController? controller;
  List itemsTemp = [];
  int itemLength = 0;
  @override
  void initState() {
    super.initState();
    setState(
      () {
        itemsTemp = explore_json;
        itemLength = explore_json.length;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Center(
          child: Stack(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                            widget.pic,
                          ),
                          fit: BoxFit.cover))),
              DraggableScrollableSheet(
                initialChildSize: 0.5,
                minChildSize: 0.5,
                maxChildSize: 0.99,
                builder: (
                  BuildContext context,
                  ScrollController scrollController,
                ) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        children: [
                          Container(
                            color: Colors.transparent,
                            child: Container(
                              margin: const EdgeInsets.only(top: 80),
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)),
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.profile,
                                          style:  const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(12),
                                            ),
                                            border: Border.all(
                                                width: 1,
                                                color: Colors.grey
                                                    .withOpacity(0.5)),
                                          ),
                                          child: const Icon(Icons.send,
                                              size: 18, color: Colors.pink),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: const TextSpan(
                                            text: "Location\n",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 16,
                                                color: Colors.black),
                                            children: [
                                              TextSpan(
                                                  text: 'Loading...',
                                                  style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400))
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 40,
                                          width: 80,
                                          decoration: BoxDecoration(
                                              color:
                                                  Colors.pink.withOpacity(0.3),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(12))),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.location_on_outlined,
                                                    color: Colors.white),
                                                Text(
                                                  '1km',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    RichText(
                                      text: const TextSpan(
                                        text: "About",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16,
                                            color: Colors.black),
                                        children: [
                                          TextSpan(
                                            text:
                                                '\n\n My name is Jessica Parker and I enjoy meeting new\n people and  finding ways to help them have an uplifting \n experience. I enjoy reading..',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Text(
                                      'Interest',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          'Gallery',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16,
                                              color: Colors.black),
                                        ),
                                        Text(
                                          'See all',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16,
                                              color: Colors.pink),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    GridView.count(
                                      shrinkWrap: true,
                                      mainAxisSpacing: 2,
                                      physics: const BouncingScrollPhysics(),
                                      crossAxisCount: 4,
                                      children: List.generate(
                                        itemLength,
                                        (index) {
                                          final imageUrl =
                                              itemsTemp[index]['img'];

                                          return GestureDetector(
                                            onTap: () {},
                                            child: Image.asset(
                                              itemsTemp[index]['img'],
                                              fit: BoxFit.cover,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 82,
                            top: 40,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                FloatingActionButton(
                                  backgroundColor: Colors.white,
                                  onPressed: () {},
                                  child: const Icon(Icons.close,
                                      color: Colors.red),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                SizedBox(
                                  height: 80.0,
                                  child: FittedBox(
                                    child: FloatingActionButton(
                                      backgroundColor: const Color(0xffE94057),
                                      onPressed: () {},
                                      hoverColor: Colors.red,
                                      child: Image.asset(
                                          'assets/images/img_10.png',
                                          height: 24),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                FloatingActionButton(
                                  backgroundColor: Colors.white,
                                  onPressed: () {},
                                  child: const Icon(Icons.star,
                                      color: Colors.purple),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
