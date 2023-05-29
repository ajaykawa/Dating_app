import 'package:flutter/material.dart';

import '../Screens/likes_screen.dart';
import '../Screens/profile_screen.dart';
import '../chatting/whatsapp_home.dart';
import 'card_swipe.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({
    super.key,
  });

  @override
  _MyNavigationBarState createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 3;
  static final List<Widget> _widgetOptions = [
    ExplorePage(),
    const LikesPage(),
    const WhatsappHome(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          iconSize: 40,
          onTap: _onItemTapped,
          elevation: 5),
    );
  }
}
