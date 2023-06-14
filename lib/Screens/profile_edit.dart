import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinderapp/Screens/profile_screen.dart';
import 'package:tinderapp/utils/datepicker.dart';
import 'package:tinderapp/utils/navigationbar.dart';

import '../bloc/authbloc/auth_bloc.dart';
import '../const.dart';
import '../controller/getxcontroller.dart';
import '../data/lists_.dart';

class ProfileEdit extends StatefulWidget {
  double total;
  ProfileEdit({Key? key, required this.total}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  Mycontrol m = Get.put(Mycontrol());
  List itemsTemp = [];
  int itemLength = 0;
  RxString enteredText = "".obs;
  RxString company = "".obs;
  RxString education = "".obs;
  String? aboutMe;
  bool selected = false;
  ScrollController _scrollController = ScrollController();
  List<String> imageURLs = [];
TextEditingController cntrler = TextEditingController();
TextEditingController jobController = TextEditingController();
TextEditingController compnyController = TextEditingController();
TextEditingController EduController = TextEditingController();
  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<File?> images = List.generate(9, (_) => null);

  Future<void> getImage(ImageSource source, int index) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) return;

    final imageTemporary = File(pickedImage.path);

    images[index] = imageTemporary;
    setState(() {});
  }

  TextEditingController text = TextEditingController();
  int med = 20;
  int abtme = 5;
  int univer = 5;
  int lang = 5;
  int life = 20;
  int jobt = 5;
  int comp = 5;
  int inter = 10;
  int gls = 5;
  int reltpe = 5;
  int edu = 5;
  bool isEnable = true;
  @override
  Widget build(BuildContext context) {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    return SafeArea(
      child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            return StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final Map<String, dynamic>? data =
                      snapshot.data!.data() as Map<String, dynamic>?;
                  final educationn = data!['Education'];
                  final companyy = data['Company Name'];
                  final jobb = data['Job Title'];
                  final String aboutme = data['about_me'];

                  final saveinterests = data['Interests'];
                  final String languagess = data['Languages'];
                  final String Pets = data['Pets Like'];
                  final String Drinking = data['Drinking Habits'];
                  final String Smoking = data['Smoking Habits'];
                  final String Diets = data['Diet Preferences'];
                  final List<String>? imagesss = data['images']?.cast<String>();
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(firebaseUser.uid)
                      .get()
                      .then((DocumentSnapshot documentSnapshot) {
                    if (documentSnapshot.exists) {
                      setState(() {
                        final data =
                            documentSnapshot.data() as Map<String, dynamic>;
                        imageURLs = List<String>.from(data['images']);
                      });
                    }
                  });

                  return GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Scaffold(
                      resizeToAvoidBottomInset: true,
                      backgroundColor: Colors.grey.shade200,
                      appBar: AppBar(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Center(
                                child: Text(
                                  'EDIT INFO',
                                  style: TextStyle(color: Colors.pinkAccent),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  total += 10;
                                  aboutMe = cntrler.text;
                                  BlocProvider.of<AuthBloc>(context)
                                      .add(SaveAboutMe(aboutme: aboutMe!));
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return  MyNavigationBar();
                                      },
                                    ),
                                  );
                                },
                                child: const Text("Save",
                                    style: TextStyle(color: Colors.pink)),
                              )
                            ],
                          ),
                          backgroundColor: Colors.white,
                          automaticallyImplyLeading: false),
                      body: Padding(
                        padding: const EdgeInsets.only(
                          right: 20,
                          left: 20,
                          top: 15,
                        ),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 20.h),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Media',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    Text(
                                      '+$med%',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 18.sp,
                                          color: Colors.pink),
                                    )
                                  ],
                                ),
                              ),
                              GridView.count(
                                crossAxisCount: 3,
                                childAspectRatio: 0.7,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: List.generate(
                                  9,
                                  (index) {
                                    if (imagesss != null &&
                                        index < imagesss.length) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: DottedBorder(
                                            borderType: BorderType.RRect,
                                            strokeWidth: 4,
                                            radius: const Radius.circular(12),
                                            child: CachedNetworkImage(
                                              imageUrl: imagesss[index],
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height
                                                  .h,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width
                                                  .w,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: DottedBorder(
                                            borderType: BorderType.RRect,
                                            strokeWidth: 4,
                                            radius: const Radius.circular(12),
                                            child: imageURLs.length > index
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                            imageURLs[index],
                                                        height:
                                                            MediaQuery.of(context)
                                                                .size
                                                                .height
                                                                .h,
                                                        width:
                                                            MediaQuery.of(context)
                                                                .size
                                                                .width
                                                                .w,
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      ),
                                                    ),
                                                  )
                                                : images[index] != null
                                                    ? Image.file(
                                                        images[index]!,
                                                        height:
                                                            MediaQuery.of(context)
                                                                .size
                                                                .height
                                                                .h,
                                                        width:
                                                            MediaQuery.of(context)
                                                                .size
                                                                .width
                                                                .w,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Center(
                                                        child:
                                                            FloatingActionButton(
                                                          heroTag: const Hero(
                                                            tag: "",
                                                            child:
                                                                Icon(Icons.add),
                                                          ),
                                                          backgroundColor:
                                                              Colors.purple[100],
                                                          child: const Icon(
                                                              Icons.add),
                                                          onPressed: () async {
                                                            getImage(
                                                                ImageSource
                                                                    .gallery,
                                                                index);
                                                            List<String>
                                                                downloadURLs = [];
                                                            final FirebaseStorage
                                                                storage =
                                                                FirebaseStorage
                                                                    .instance;
                                                            for (File? image
                                                                in images) {
                                                              if (image != null) {
                                                                final ref = storage
                                                                    .ref()
                                                                    .child(
                                                                        'images/${DateTime.now().toString()}');
                                                                final uploadTask =
                                                                    ref.putFile(
                                                                        image);
                                                                final snapshot =
                                                                    await uploadTask
                                                                        .whenComplete(
                                                                            () {});
                                                                final downloadURL =
                                                                    await snapshot
                                                                        .ref
                                                                        .getDownloadURL();
                                                                downloadURLs.add(
                                                                    downloadURL);
                                                              }
                                                            }

                                                            // Save download URLs to Firestore
                                                            final CollectionReference
                                                                users =
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'users');
                                                            final firebaseAuth =
                                                                FirebaseAuth
                                                                    .instance;
                                                            final firebaseUser =
                                                                firebaseAuth
                                                                    .currentUser;
                                                            final userId =
                                                                firebaseUser!.uid;
                                                            final DocumentReference
                                                                user =
                                                                users.doc(userId);
                                                            await user.set(
                                                              {
                                                                'images': FieldValue
                                                                    .arrayUnion(
                                                                        downloadURLs)
                                                              },
                                                              SetOptions(
                                                                  merge: true),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 20.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'About Me',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  Text(
                                    '+$abtme%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp,
                                        color: Colors.pink),
                                  )
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                height: 100.h,
                                width: MediaQuery.of(context).size.width.w,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: TextField(onTap: () {
                                    cntrler.text = aboutme;
                                  },
                                    maxLength: 350,

                                    controller: cntrler,keyboardType: TextInputType.text,
                                    minLines: 4,
                                    maxLines: 5,autofocus: false,
                                    style: TextStyle(
                                        fontSize: 16.sp, color: Colors.grey),
                                    decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(10),
                                      border: InputBorder.none,
                                      hintText: aboutme ??
                                          "Write Something about yourself",
                             ),

                                  ),
                                ),
                              ),
                              SizedBox(height: 20.h),
                              const BirthdayPicker(),
                              SizedBox(
                                height: 10.h,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Interests',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  Text(
                                    '+$inter%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp,
                                        color: Colors.pink),
                                  )
                                ],
                              ),
                              SizedBox(height: 10.h),
                              GridView.count(
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: 3,
                                childAspectRatio: 2,
                                shrinkWrap: true,
                                children: List.generate(
                                  interestsss.length,
                                  (index) {
                                    final interest = interestsss[index];
                                    final isSelected =
                                        saveinterests.contains(interest);
                                    return Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: InterestSelection(
                                        text: interest,
                                        isSelected: isSelected,
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          final newSelected = !isSelected;
                                          final updatedInterests =
                                              List<String>.from(saveinterests);
                                          if (newSelected) {
                                            updatedInterests.add(interest);
                                          } else {
                                            updatedInterests.remove(interest);
                                          }
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(userId)
                                              .update({
                                            'Interests': updatedInterests
                                          });
                                        },
                                        Iconn: icons[index],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Relaitonship Goals',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  Text(
                                    '+$gls%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp,
                                        color: Colors.pink),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  showModalBottomSheet(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35.0),
                                    ),
                                    enableDrag: true,
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 5.h,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.2.w,
                                                  decoration: const BoxDecoration(
                                                    color: Colors.black54,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(12),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 65.h),
                                            Text(
                                              "Right now I'm looking for...",
                                              style: TextStyle(
                                                  fontSize: 24.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "Increase compatibility by sharing yours!",
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            SizedBox(height: 10.h),
                                            GridView.count(
                                              crossAxisCount: 3,
                                              childAspectRatio: 1,
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              children: List.generate(
                                                relationshipgoals.length,
                                                (index) {
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      FocusScope.of(context).unfocus();
                                                      m.selectedRelationshipGoal =
                                                          relationshipgoals[index]
                                                              .obs;
                                                      m.selectedIcon =
                                                          FontAwesomeIcons.clover;
                                                      BlocProvider.of<AuthBloc>(
                                                              context)
                                                          .add(
                                                        SaveRelationShipGoal(
                                                          reltngoals:
                                                              relationshipgoals[
                                                                  index],
                                                        ),
                                                      );
                                                      total = 10;
                                                      Navigator.pop(context);
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2.0),
                                                      child: Container(
                                                        height: 35.h,
                                                        width: 35.w,
                                                        decoration: BoxDecoration(
                                                          color: m.selectedRelationshipGoal ==
                                                                  relationshipgoals[
                                                                      index]
                                                              ? Colors.blueGrey
                                                                  .withOpacity(
                                                                      0.5)
                                                              : Colors.blueGrey
                                                                  .withOpacity(
                                                                      0.2),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(
                                                            Radius.circular(18),
                                                          ),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            loveicons[index],
                                                            Text(
                                                              relationshipgoals[
                                                                  index],
                                                              textAlign: TextAlign
                                                                  .center,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 50.h,
                                  width: MediaQuery.of(context).size.width.w,
                                  margin: const EdgeInsets.only(top: 12),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.remove_red_eye_sharp),
                                        SizedBox(width: 10.w),
                                        const Text("Looking for",
                                            style:
                                                TextStyle(color: Colors.black54)),
                                        const Spacer(),
                                        m.selectedIcon != null
                                            ? Icon(m.selectedIcon, size: 16)
                                            : const SizedBox(),
                                        Obx(() => Text(
                                            m.selectedRelationshipGoal.value)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Relationship type',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  Text(
                                    '+$reltpe%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp,
                                        color: Colors.pink),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  showModalBottomSheet(
                                    useRootNavigator: true,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35.0),
                                    ),
                                    enableDrag: true,
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, state) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.4.h,
                                              child: Column(
                                                children: [
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 4.h,
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.2.w,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.black54,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(12),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 40.h),
                                                  Text(
                                                    "Relationship Type...",
                                                    style: TextStyle(
                                                        fontSize: 24.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(height: 20.h),
                                                  Text(
                                                    "What type of relationship are you open to?",
                                                    style: TextStyle(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                  SizedBox(height: 20.h),
                                                  GridView.count(
                                                    crossAxisCount: 2,
                                                    childAspectRatio: 3,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    children: List.generate(
                                                      relationtype.length,
                                                      (index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child:
                                                              InterestSelection(
                                                            text: relationtype[
                                                                index],
                                                            isSelected:
                                                                m.relationshiptype[
                                                                    index],
                                                            onTap: () {
                                                              m.SetSelectedRelationtype(
                                                                  index);
                                                              BlocProvider.of<
                                                                          AuthBloc>(
                                                                      context)
                                                                  .add(SaveRelationShipType(
                                                                      relationtype: m
                                                                          .selectedtype
                                                                          .join(
                                                                              ", ")));
                                                              total += 10;
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            Iconn: icons[index],
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 50.h,
                                  width: MediaQuery.of(context).size.width.w,
                                  margin: const EdgeInsets.only(top: 12),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.remove_red_eye_sharp),
                                        SizedBox(width: 10.w),
                                        const Text("Open to"),
                                        const Spacer(),
                                        Obx(() =>
                                            Text(m.selectedtype.join(", "))),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Languages I Know',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  Text(
                                    '+$lang%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp,
                                        color: Colors.pink),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  showModalBottomSheet(
                                    useRootNavigator: true,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(35.0),
                                    ),
                                    enableDrag: true,
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, state) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.9.h,
                                              child: Column(
                                                children: [
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        height: 4.h,
                                                        width:
                                                            MediaQuery.of(context)
                                                                    .size
                                                                    .width *
                                                                0.2.w,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.black54,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(12),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 20.h),
                                                  Text(
                                                    "Select Languages...",
                                                    style: TextStyle(
                                                      fontSize: 24.sp,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  Text(
                                                    "What type of languagess you are familiar with ?",
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w300,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10.h),
                                                  GridView.count(
                                                    crossAxisCount: 3,
                                                    childAspectRatio: 2.5,
                                                    shrinkWrap: true,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    children: List.generate(
                                                      languages.length,
                                                      (index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2.0),
                                                          child: Obx(
                                                            () =>
                                                                InterestSelection(
                                                              text: languages[
                                                                  index],
                                                              isSelected:
                                                                  m.languageknow[
                                                                      index],
                                                              onTap: () {
                                                                m.languageKnown(
                                                                    index);
                                                                m.setSelectedLanguages(
                                                                    m.getSelectedLanguages());
                                                              },
                                                              Iconn: const Icon(Icons
                                                                  .control_point),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(height: 20.h),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      m.setSelectedLanguages(m
                                                          .getSelectedLanguages());
                                                      BlocProvider.of<AuthBloc>(
                                                              context)
                                                          .add(SaveLanguages(
                                                        languages: m
                                                            .getSelectedLanguages()
                                                            .value,
                                                      ));
                                                      total += 5;
                                                      Navigator.pop(context);
                                                    },
                                                    style: const ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                                Colors.pink)),
                                                    child: const Text("Save"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  height: 50.h,
                                  width: MediaQuery.of(context).size.width.w,
                                  margin: const EdgeInsets.only(top: 12),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.language_sharp),
                                        SizedBox(width: 10.w),
                                        const Text("Languages"),
                                        SizedBox(width: 30.w),
                                        Flexible(
                                          child: Obx(
                                            () => Text(
                                              m.getSelectedLanguages().value,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Lifestyle',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  Text(
                                    '+$life%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp,
                                        color: Colors.pink),
                                  )
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width.w,
                                margin: const EdgeInsets.only(top: 12),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12))),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: GestureDetector(
                                          onTap: () {
                                            FocusScope.of(context).unfocus();
                                            showModalBottomSheet(
                                              useRootNavigator: true,
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(35.0),
                                              ),
                                              enableDrag: true,
                                              context: context,
                                              builder: (context) {
                                                return StatefulBuilder(
                                                  builder: (context, state) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Column(
                                                        children: [
                                                          Center(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Container(
                                                                height: 4.h,
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.2.w,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Colors
                                                                      .black54,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .all(
                                                                    Radius
                                                                        .circular(
                                                                            12),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 65.h),
                                                          Text(
                                                            "Do you have any pets..?",
                                                            style: TextStyle(
                                                                fontSize: 24.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          SizedBox(height: 20.h),
                                                          GridView.count(
                                                            crossAxisCount: 2,
                                                            childAspectRatio: 2.5,
                                                            shrinkWrap: true,
                                                            physics:
                                                                const BouncingScrollPhysics(),
                                                            children:
                                                                List.generate(
                                                              pets.length,
                                                              (index) {
                                                                return Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          2.0),
                                                                  child:
                                                                      InterestSelection(
                                                                    text: pets[
                                                                        index],
                                                                    isSelected:
                                                                        m.petslike[
                                                                            index],
                                                                    onTap: () {
                                                                      m.PetsSelected(
                                                                          index);
                                                                      BlocProvider.of<AuthBloc>(
                                                                              context)
                                                                          .add(SaveSelectedPet(
                                                                              pet:
                                                                                  m.selectedPetsList.join(", ")));
                                                                      total += 5;
                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    Iconn: const Icon(
                                                                        Icons
                                                                            .pets_sharp),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            decoration: const BoxDecoration(
                                                color: Colors.transparent),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.pets),
                                                SizedBox(width: 10.w),
                                                const Text("Pets"),
                                                const Spacer(),
                                                Obx(() => Text(m.selectedPetsList
                                                        .join(", ") ??
                                                    Pets))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(height: 2.h, thickness: 2),
                                      GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(35.0),
                                            ),
                                            enableDrag: true,
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                builder: (context, state) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      children: [
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              height: 4.h,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.2.w,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .black54,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius.circular(
                                                                      12),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 65.h),
                                                        Text(
                                                          "How often do you drink..?",
                                                          style: TextStyle(
                                                              fontSize: 24.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(height: 20.h),
                                                        GridView.count(
                                                          crossAxisCount: 2,
                                                          childAspectRatio: 3,
                                                          shrinkWrap: true,
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          children: List.generate(
                                                            drink.length,
                                                            (index) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(2.0),
                                                                child:
                                                                    InterestSelection(
                                                                  text: drink[
                                                                      index],
                                                                  isSelected:
                                                                      m.drinkhabits[
                                                                          index],
                                                                  onTap: () {
                                                                    state(
                                                                      () {
                                                                        m.DrinkingHabits(
                                                                            index);
                                                                      },
                                                                    );
                                                                    BlocProvider.of<
                                                                                AuthBloc>(
                                                                            context)
                                                                        .add(SaveDrinkingHabits(
                                                                            drinkinghabit: m
                                                                                .selectedDrinkingHabit
                                                                                .value));
                                                                    total += 5;
                                                                    Get.back();
                                                                    // Navigator.pop(context);
                                                                  },
                                                                  Iconn: const Icon(
                                                                      Icons
                                                                          .wine_bar),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.transparent),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12, top: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(Icons.wine_bar),
                                                SizedBox(width: 10.w),
                                                const Text("Drinking"),
                                                const Spacer(),
                                                Obx(() => Text(
                                                    m.selectedDrink.join(", ") ??
                                                        Drinking))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Divider(height: 2.h, thickness: 2),
                                      GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            enableDrag: true,
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                builder: (context, state) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      children: [
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              height: 4.h,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.2.w,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .black54,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius.circular(
                                                                      12),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 65.h),
                                                        Text(
                                                          "How often do you Smoke..?",
                                                          style: TextStyle(
                                                              fontSize: 24.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(height: 20.h),
                                                        GridView.count(
                                                          crossAxisCount: 2,
                                                          childAspectRatio: 3,
                                                          shrinkWrap: true,
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          children: List.generate(
                                                            smoke.length,
                                                            (index) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(2.0),
                                                                child:
                                                                    InterestSelection(
                                                                  text: smoke[
                                                                      index],
                                                                  isSelected:
                                                                      m.smokehabits[
                                                                          index],
                                                                  onTap: () {
                                                                    m.Smokinghabits(
                                                                        index);

                                                                    BlocProvider.of<
                                                                                AuthBloc>(
                                                                            context)
                                                                        .add(SaveSmokingHabits(
                                                                            smokinghabits: m
                                                                                .selectedSmokeHabit
                                                                                .value));
                                                                    total += 5;
                                                                  },
                                                                  Iconn: const Icon(
                                                                      Icons
                                                                          .wine_bar),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.transparent),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12, top: 12),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const Icon(
                                                    Icons.smoking_rooms_outlined),
                                                SizedBox(width: 10.w),
                                                const Text("Smoking"),
                                                const Spacer(),
                                                Obx(() => Text(
                                                    m.selectedSmoke.join(", ") ??
                                                        Smoking))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Divider(height: 2, thickness: 2),
                                      GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          showModalBottomSheet(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            enableDrag: true,
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) {
                                              return StatefulBuilder(
                                                builder: (context, state) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      children: [
                                                        Center(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Container(
                                                              height: 4.h,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.2.w,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Colors
                                                                    .black54,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius.circular(
                                                                      12),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 65.h),
                                                        Text(
                                                          "What are your diet preferences..?",
                                                          style: TextStyle(
                                                              fontSize: 24.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        SizedBox(height: 20.h),
                                                        GridView.count(
                                                          crossAxisCount: 2,
                                                          childAspectRatio: 3,
                                                          shrinkWrap: true,
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          children: List.generate(
                                                            diet.length,
                                                            (index) {
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(2.0),
                                                                child:
                                                                    InterestSelection(
                                                                  text:
                                                                      diet[index],
                                                                  isSelected: m
                                                                      .dietprefer
                                                                      .value[index],
                                                                  onTap: () {
                                                                    m.DietPref(
                                                                        index);

                                                                    BlocProvider.of<
                                                                                AuthBloc>(
                                                                            context)
                                                                        .add(
                                                                      SaveDietPreferences(
                                                                        dietpreferences: m
                                                                            .selectedDietpref
                                                                            .join(
                                                                                ", "),
                                                                      ),
                                                                    );
                                                                    total += 5;
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  Iconn: const Icon(
                                                                      Icons
                                                                          .fastfood_outlined),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.transparent),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12, top: 12),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  color: Colors.transparent),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                      Icons.fastfood_rounded),
                                                  SizedBox(width: 10.w),
                                                  const Text("Diet preferences"),
                                                  const Spacer(),
                                                  Obx(() => Text(m
                                                          .selectedDietpref
                                                          .join(", ") ??
                                                      Diets)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Job Title ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  Text(
                                    '+$jobt%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp,
                                        color: Colors.pink),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  jobController.text = jobb;
                                  FocusScope.of(context).unfocus();
                                  openAlertBox((text) {
                                    enteredText.value = text;
                                    BlocProvider.of<AuthBloc>(context)
                                        .add(SaveJobTitle(
                                      jobtitle: enteredText.value,
                                    ));
                                  }, "Job Title",jobController);
                                },
                                child: Container(
                                  height: 50.h,
                                  width: MediaQuery.of(context).size.width.w,
                                  margin: const EdgeInsets.only(top: 12),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.work_outlined),
                                        SizedBox(width: 10.w),
                                        const Text("Job "),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.13.w,
                                        ),
                                        const Icon(Icons.work_outline),
                                        SizedBox(width: 10.w),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.38.w,
                                          child: Text(
                                            jobb ?? enteredText.value,
                                            style: TextStyle(fontSize: 16.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Company',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  Text(
                                    '+$comp%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp,
                                        color: Colors.pink),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  compnyController.text = companyy;
                                  FocusScope.of(context).unfocus();
                                  openAlertBox((text) {
                                    company.value = text;

                                    BlocProvider.of<AuthBloc>(context)
                                        .add(SaveCompanyName(
                                      companyname: company.value,
                                    ));
                                  }, "Company Name",compnyController);
                                },
                                child: Container(
                                  height: 50.h,
                                  width: MediaQuery.of(context).size.width.w,
                                  margin: const EdgeInsets.only(top: 12),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.local_post_office),
                                        SizedBox(width: 5.w),
                                        const Text("Company Name"),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        const Icon(Icons.work_outline),
                                        SizedBox(width: 10.w),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.2.w,
                                          child: Text(
                                            companyy ?? company.value,
                                            style: TextStyle(fontSize: 16.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Education',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.sp,
                                    ),
                                  ),
                                  Text(
                                    '+$edu%',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.sp,
                                        color: Colors.pink),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  EduController.text = educationn;
                                  FocusScope.of(context).unfocus();
                                  openAlertBox((text) async {
                                    education.value = text;

                                    BlocProvider.of<AuthBloc>(context)
                                        .add(SaveEducation(
                                      education: education.value,
                                    ));
                                  }, "University Name",EduController);
                                },
                                child: Container(
                                  height: 50.h,
                                  width: MediaQuery.of(context).size.width.w,
                                  margin: const EdgeInsets.only(top: 12),
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(12))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.school),
                                        SizedBox(width: 10.w),
                                        const Text("University Name "),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        const Icon(Icons.school_outlined),
                                        SizedBox(width: 10.w),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width *
                                                  0.2.w,
                                          child: Text(
                                            educationn ?? education.value,
                                            style: TextStyle(fontSize: 16.sp),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
          }),
    );
  }

  openAlertBox(Function(String) onDone, String str, TextEditingController cntrl) {
    RxString enteredText =
        "".obs; // initialize a variable to hold the entered text
    showModalBottomSheet<dynamic>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          reverse: true,
          child: StatefulBuilder(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        str,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.pink,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border:
                                Border.all(width: 1.w, color: Colors.black)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                          ),
                          child: TextField(
                            decoration: const InputDecoration(
                              hintText: "Input your details",
                              border: InputBorder.none,
                            ),controller: cntrl,
                            autofocus: true,
                            maxLines: 2,
                            maxLength: 25,
                            onChanged: (value) {
                              enteredText.value =
                                  value; // update the entered text variable
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    InkWell(
                      onTap: () {
                        total += 5;
                        Navigator.of(context).pop();
                        onDone(enteredText.value);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 60),
                        height: 40.h,
                        width: MediaQuery.of(context).size.width * 0.3.w,
                        decoration: const BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: const Center(
                          child: Text(
                            "Done!",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).viewInsets.bottom.h),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
