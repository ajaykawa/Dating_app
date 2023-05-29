import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

const Color white = Colors.white;
const Color grey = Colors.grey;
const Color black = Colors.black;
const Color green = Colors.green;
const Color primary = Color(0xFFFD5C61);

// gradient
const Color yellow_one = Color(0xFFeec365);
const Color yellow_two = Color(0xFFde9024);
const Color primary_one = Color(0xFFfc3973);
const Color primary_two = Color(0xFFfd5f60);

class ProfileTextFields extends StatefulWidget {
  final TextEditingController controller;
  final String hinttext;
  final String title;
 final double? height;
 final TextAlign textAlign;
 final int? maxLines;
  const ProfileTextFields({
    Key? key,
    required this.controller,
    required this.hinttext,
    required this.title,
    this.height, required this.textAlign, this.maxLines, required String? Function(dynamic value) validator,
  }) : super(key: key);

  @override
  State<ProfileTextFields> createState() => _ProfileTextFieldsState();
}

class _ProfileTextFieldsState extends State<ProfileTextFields> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Container(
          height: widget.height,
          decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: const BorderRadius.all(Radius.circular(15)),
          border: Border.all(width: 2,color: Colors.purple)
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: widget.controller,textAlign: widget.textAlign ,maxLines: widget.maxLines,
                decoration: InputDecoration.collapsed(
                  hintText: widget.hinttext,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//--------------------------------------------------------------------------------------------------------

class Gender extends StatefulWidget {
  final String text;
  const Gender({Key? key, required this.text}) : super(key: key);

  @override
  State<Gender> createState() => _GenderState();
}

class _GenderState extends State<Gender> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.pink[200],
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: Center(
          child: Text(widget.text,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white))),
    );
  }
}

//-------------------------------------------------------------------------------------------------------------------

class InterestSelection extends StatefulWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  final Icon Iconn;
  const InterestSelection({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.Iconn,
  }) : super(key: key);

  @override
  State<InterestSelection> createState() => _InterestSelectionState();
}

class _InterestSelectionState extends State<InterestSelection> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          height: 50,
          width: 60,
          decoration: BoxDecoration(
            color: widget.isSelected  ?  Colors.purple.shade100
                : Colors.purple[50],
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: Border.all(
              color: widget.isSelected ?  Colors.purple.shade600: Colors.purple[100]!,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              widget.Iconn,
              Text(
                widget.text,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: widget.isSelected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//---------------------------------------------------------------------------------------------------------------

class Fields extends StatefulWidget {
  const Fields({Key? key}) : super(key: key);

  @override
  State<Fields> createState() => _FieldsState();
}

class _FieldsState extends State<Fields> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BIO',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: InputDecoration.collapsed(
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white),
              maxLines: 4,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        )
      ],
    );
  }
}

//--------------------------------------------------------------------------------------------------------------

class BottomFields extends StatefulWidget {
  final String title;
  const BottomFields({Key? key, required this.title}) : super(key: key);

  @override
  State<BottomFields> createState() => _BottomFieldsState();
}

class _BottomFieldsState extends State<BottomFields> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.pink.shade100)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onPressed: () {
          // when raised button is pressed
          // we display showModalBottomSheet
          showModalBottomSheet<void>(
            // context and builder are
            // required properties in this widget
            context: context,
            builder: (BuildContext context) {
              // we set up a container inside which
              // we create center column and display text

              // Returning SizedBox instead of a Container
              return SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text('GeeksforGeeks'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      // RaisedButton is deprecated and should not be used
      // Use ElevatedButton instead.

      // child: RaisedButton(
      //     child: const Text('showModalBottomSheet'),
      //     onPressed: () {

      //     // when raised button is pressed
      //     // we display showModalBottomSheet
      //     showModalBottomSheet<void>(

      //         // context and builder are
      //         // required properties in this widget
      //         context: context,
      //         builder: (BuildContext context) {

      //         // we set up a container inside which
      //         // we create center column and display text
      //         return Container(
      //             height: 200,
      //             child: Center(
      //             child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 children: <Widget>[
      //                 const Text('GeeksforGeeks'),
      //                 ],
      //             ),
      //             ),
      //         );
      //         },
      //     );
      //     },
      // ),
    );
  }
}
//--------------------------------------------------------------------------------------------------------------------------------

class InterestFields extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final double? height;

  InterestFields({
    Key? key,
    required this.controller,

    required this.title,
    this.height, required text, required Icon Iconn,
  }) : super(key: key);

  @override
  State<InterestFields> createState() => _InterestFieldsState();
}

class _InterestFieldsState extends State<InterestFields> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Container(
          height: widget.height,
          decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: const BorderRadius.all(Radius.circular(15))),
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(''
              ),
            ),
          ),
        ),
      ],
    );
  }
}
//==============================================================================================================================

class Interests extends StatefulWidget {
  final String text;
  final Icon Iconn;
  const Interests({
    Key? key,
    required this.text,


    required this.Iconn,
  }) : super(key: key);

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 50,
        width: 80,
        decoration: BoxDecoration(
          color:Colors.pink[200] ,
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          border: Border.all(
            color: Colors.pink[600]!,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            widget.Iconn,
            Text(
              widget.text,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color:Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


errorSnackbar(String description) {
  Get.snackbar(
    "Oops! something went wrong",
    description,
    shouldIconPulse: true,
    colorText: Colors.white,
    backgroundColor: Colors.red,
    icon: const Icon(
      Icons.error,
      color: Colors.white,
    ),
  );
}

successSnackbar(String description) {
  Get.snackbar(
      "Successful!",
      description,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: Colors.green,
      icon: const Icon(
          Icons.check,
          color: Colors.white,
          ),
      );
}