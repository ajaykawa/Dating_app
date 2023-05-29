import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BirthdayPicker extends StatefulWidget {
  const BirthdayPicker({Key? key}) : super(key: key);

  @override
  _BirthdayPickerState createState() => _BirthdayPickerState();
}

class _BirthdayPickerState extends State<BirthdayPicker> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _getSavedBirthDate();
  }

  Future<void> _getSavedBirthDate() async {
    final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentSnapshot userSnapshot = await users.doc(userId).get();
    final birthDate = userSnapshot.get('Birth Date');
    if (birthDate != null) {
      setState(() {
        _selectedDate = birthDate.toDate();
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
    _saveBirthdate();
  }

  Future<void> _saveBirthdate() async {
    final CollectionReference users =
    FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user = users.doc(userId);
    await user.set(
        {'Birth Date': _selectedDate}, SetOptions(merge: true));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _selectDate(context);
      },
      child: Center(
        child: Container(
          height: 45.h,
          padding: const EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(24))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children:  [
                  const Icon(Icons.calendar_month, color: Colors.black),
                  Text(
                    "+15%",
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.pink),
                  ),
                ],
              ),
              Text(
                _selectedDate == null
                    ? 'Birth Date'
                    : DateFormat.yMd().format(_selectedDate!),
                style:  TextStyle(color: Colors.black, fontSize: 16.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
