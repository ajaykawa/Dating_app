import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinderapp/Screens/ur_interest.dart';

import '../bloc/authbloc/auth_bloc.dart';

class ImageSelection extends StatefulWidget {
  const ImageSelection({Key? key}) : super(key: key);

  @override
  State<ImageSelection> createState() => _ImageSelectionState();
}

class _ImageSelectionState extends State<ImageSelection> {
  List<File?> images = List.generate(9, (_) => null);
  final FirebaseStorage storage = FirebaseStorage.instance;
  bool isLoading = false;
  Future<void> getImage(ImageSource source, int index) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage == null) return;

    final imageTemporary = File(pickedImage.path);

    setState(() {
      images[index] = imageTemporary;
    });
  }

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
      child: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    Text(
                      "Upload Your Photos",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30.sp,
                      ),
                    ),
                    GridView.count(
                      crossAxisCount: 3,
                      childAspectRatio: 0.7,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: List.generate(9, (index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: DottedBorder(
                              borderType: BorderType.RRect,
                              strokeWidth: 4,
                              radius: Radius.circular(12.r),
                              child: images[index] != null
                                  ? Image.file(
                                      images[index]!,
                                      height:
                                          MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                    )
                                  : Center(
                                      child: FloatingActionButton(
                                        backgroundColor: Colors.purple[100],
                                        child: const Icon(Icons.add),
                                        onPressed: () {
                                          getImage(ImageSource.gallery, index);
                                        },
                                      ),
                                    ),
                            ),
                          ),
                        );
                      }),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        // Check if at least 3 images are uploaded
                        int uploadedCount =
                            images.where((image) => image != null).length;
                        if (uploadedCount < 3) {
                          Get.snackbar("Image Not Uploaded",
                              "You have to upload least 3 images!");
                          return;
                        }

                        // Set loading state
                        setState(() {
                          isLoading = true;
                        });

                        // Show loading indicator
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                                'Please wait while your photos are uploading'),
                            duration: const Duration(milliseconds: 1000),
                            backgroundColor: Colors.black,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            action: SnackBarAction(
                              label: 'Cancel',
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                setState(() {
                                  isLoading = false;
                                });
                              },
                            ),
                          ),
                        );

                        List<String> downloadURLs = [];
                        for (File? image in images) {
                          if (image != null) {
                            final ref = storage
                                .ref()
                                .child('images/${DateTime.now().toString()}');
                            final uploadTask = ref.putFile(image);
                            final snapshot =
                                await uploadTask.whenComplete(() {});
                            final downloadURL =
                                await snapshot.ref.getDownloadURL();
                            downloadURLs.add(downloadURL);
                          }
                        }

                        // Save download URLs to Firestore
                        final CollectionReference users =
                            FirebaseFirestore.instance.collection('users');
                        final firebaseAuth = FirebaseAuth.instance;
                        final firebaseUser = firebaseAuth.currentUser;
                        final userId = firebaseUser!.uid;
                        final DocumentReference user = users.doc(userId);
                        await user.update({'images': downloadURLs});

                        // Reset loading state
                        setState(() {
                          isLoading = false;
                        });

                        // Navigate to next screen
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return const YourInterest();
                          },
                        ));
                      },
                      child: Container(
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            stops: const [
                              0.1,
                              0.4,
                              0.6,
                              0.9,
                            ],
                            colors: [
                              Colors.purple.shade600,
                              Colors.purple.shade300,
                              Colors.purple.shade200,
                              Colors.purple.shade700,
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            isLoading ? 'Loading...' : 'Next',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
