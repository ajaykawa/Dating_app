// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'chat_options.dart';
//
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({Key? key}) : super(key: key);
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             physics:const BouncingScrollPhysics(),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Messages',
//                       style:
//                           TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
//                     ),
//                     Container(
//                       height: 40,
//                       width: 40,
//                       decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.all(
//                           Radius.circular(12),
//                         ),
//                         border: Border.all(width: 1, color: Colors.pink),
//                       ),
//                       child: const Icon(Icons.settings_input_composite_outlined,
//                           color: Colors.pink),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Container(
//                     height: 50,
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.all(
//                           Radius.circular(20),
//                         ),
//                         border: Border.all(
//                             width: 1, color: Colors.black.withOpacity(0.5))),
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextField(
//                         decoration: InputDecoration(
//                           icon: Icon(Icons.search),
//                           border: InputBorder.none,
//                           hintText: 'Search',hintStyle: TextStyle(fontSize: 16),
//                         ),
//                         style: TextStyle(color: Colors.grey, fontSize: 16),
//                       ),
//                     )),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Activities',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//                 ),
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: const [
//                       Stores(
//                         name: 'You',
//                         picture: 'assets/images/img.png',
//                       ),
//                       Stores(
//                         name: 'A',
//                         picture: 'assets/images/img2.jpeg',
//                       ),
//                       Stores(
//                         name: 'B',
//                         picture: 'assets/images/img1.jpeg',
//                       ),
//                       Stores(
//                         name: 'C',
//                         picture: 'assets/images/img3.jpeg',
//                       ),
//                       Stores(
//                         name: 'D',
//                         picture: 'assets/images/img6.jpeg',
//                       ),
//                       Stores(
//                         name: 'E',
//                         picture: 'assets/images/img_3.png',
//                       ),
//                       Stores(
//                         name: 'F',
//                         picture: 'assets/images/img_5.png',
//                       ),
//                       Stores(
//                         name: 'G',
//                         picture: 'assets/images/img_6.png',
//                       ),
//                       Stores(
//                         name: 'H',
//                         picture: 'assets/images/img3.jpeg',
//                       ),
//                       Stores(
//                         name: 'I',
//                         picture: 'assets/images/img1.jpeg',
//                       )
//                     ],
//                   ),
//                 ),
//                 const Text(
//                   'Messages',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
//                 ),
//                 const SizedBox(height: 20),
//                 const Chatssss(
//                   name: 'Emilie',
//                   picture: 'assets/images/img.png',
//                 ),
//                 Divider(thickness: 1),
//                 const Chatssss(
//                   name: 'Grace',
//                   picture: 'assets/images/img_1.png',
//                 ),
//                 Divider(thickness: 1),
//                 const Chatssss(
//                   name: 'Darshit',
//                   picture: 'assets/images/img_3.png',
//                 ),
//                 Divider(thickness: 1),
//                 const Chatssss(
//                   name: 'Rahul',
//                   picture: 'assets/images/img_4.png',
//                 ),
//                 Divider(thickness: 1),
//                 const Chatssss(
//                   name: 'Ankit',
//                   picture: 'assets/images/img_5.png',
//                 ),
//                 const Divider(thickness: 1),
//                 Chatssss(
//                   name: 'Nikhil',
//                   picture: 'assets/images/img.png',
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class Chatssss extends StatelessWidget {
//   const Chatssss({super.key,
//     required this.name,
//     required this.picture,
//   });
//   final String name;
//   final String picture;
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => const ChatPage(),
//           ),
//         );
//       },
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           CircleAvatar(
//             radius: 35,
//             backgroundImage: AssetImage(picture),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text(name,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 18)),
//                 Text(name,
//                     style: const TextStyle(
//                         fontWeight: FontWeight.normal, fontSize: 16)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class Stores extends StatelessWidget {
//   const Stores({
//     super.key,
//     required this.name,
//     required this.picture,
//   });
//   final String name;
//   final String picture;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 35,
//             backgroundImage: AssetImage(picture),
//           ),
//           Text(
//             name,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//           )
//         ],
//       ),
//     );
//   }
// }
