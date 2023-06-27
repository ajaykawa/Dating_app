import 'package:flutter/material.dart';

import '../Screens/likes_screen.dart';
import '../Screens/profile_screen.dart';
import '../chatting/whatsapp_home.dart';
import 'card_swipe.dart';

class MyNavigationBar extends StatefulWidget {
  late  int i;

   MyNavigationBar({super.key, required this.i});

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {

  static final List<Widget> _widgetOptions = [
    ExplorePage(),
     LikesPage(),
     WhatsappHome(),
     ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      widget.i = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(widget.i),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
                icon: Icon(Icons.home, color: Colors.purple, size: 32),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Image.asset('assets/images/img_10.png',
                    color: Colors.purple, height: 24),
                label: 'Likes'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.chat, color: Colors.purple, size: 32),
                label: 'Chats'),
            const BottomNavigationBarItem(
                icon: Icon(Icons.person, color: Colors.purple, size: 32),
                label: 'Profile'),
          ],
          type: BottomNavigationBarType.fixed,
          currentIndex: widget.i,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5),
    );
  }
}
