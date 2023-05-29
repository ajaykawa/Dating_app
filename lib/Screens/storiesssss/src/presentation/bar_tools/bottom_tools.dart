import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_media_picker/gallery_media_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stories_editor/src/domain/providers/notifiers/control_provider.dart';
import 'package:stories_editor/src/domain/providers/notifiers/draggable_widget_notifier.dart';
import 'package:stories_editor/src/domain/providers/notifiers/scroll_notifier.dart';
import 'package:tinderapp/Screens/storiesssss/src/presentation/widgets/animated_onTap_button.dart';

class BottomTools extends StatefulWidget {
  final GlobalKey contentKey;
  final Function(String imageUri) onDone;
  final Widget? onDoneButtonStyle;
  final Color? editorBackgroundColor;
  BottomTools({
    Key? key,
    required this.contentKey,
    required this.onDone,
    this.onDoneButtonStyle,
    this.editorBackgroundColor,
  }) : super(key: key);

  @override
  State<BottomTools> createState() => _BottomToolsState();
}

class _BottomToolsState extends State<BottomTools> {
  bool isLoading = false;

  List<String> existingImages = [];
  Future<void> _deleteStoriesAfterDelay(
      String userId, List<String> stories) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final DocumentReference userRef = users.doc(userId);

    await Future.delayed(const Duration(hours:  10));

    final DocumentSnapshot userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      final data = userSnapshot.data();
      if (data != null &&
          data is Map<String, dynamic> &&
          data.containsKey('Story`s')) {
        List<String> existingImages = List<String>.from(data['Story`s']);
        existingImages.removeWhere((image) => stories.contains(image));
        await userRef.update({'Story`s': existingImages});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ControlNotifier, ScrollNotifier, DraggableWidgetNotifier>(
      builder: (_, controlNotifier, scrollNotifier, itemNotifier, __) {
        return Container(
          decoration: const BoxDecoration(color: Colors.transparent),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      child: _preViewContainer(
                        /// if [model.imagePath] is null/empty return preview image
                        child: controlNotifier.mediaPath.isEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: GestureDetector(
                                  onTap: () {
                                    /// scroll to gridView page
                                    if (controlNotifier.mediaPath.isEmpty) {
                                      scrollNotifier.pageController
                                          .animateToPage(
                                        1,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        curve: Curves.ease,
                                      );
                                    }
                                  },
                                  child: const CoverThumbnail(
                                    thumbnailQuality: 150,
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  controlNotifier.mediaPath = '';
                                  itemNotifier.draggableWidget.removeAt(0);
                                },
                                child: Container(
                                  height: 45,
                                  width: 45,
                                  color: Colors.transparent,
                                  child: Transform.scale(
                                    scale: 0.7,
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Transform.scale(
                      scale: 0.9,
                      child: AnimatedOnTapButton(
                        onTap: () async {
                          try {
                            // Existing image URLs
                            setState(() {
                              isLoading = true;
                            });
                            // Retrieve existing image URLs from Firebase
                            final CollectionReference users =
                                FirebaseFirestore.instance.collection('users');
                            final firebaseAuth = FirebaseAuth.instance;
                            final firebaseUser = firebaseAuth.currentUser;
                            final userId = firebaseUser!.uid;
                            final DocumentSnapshot userSnapshot =
                                await users.doc(userId).get();

                            if (userSnapshot.exists) {
                              final data = userSnapshot.data();
                              if (data != null &&
                                  data is Map<String, dynamic> &&
                                  data.containsKey('Story`s')) {
                                existingImages =
                                    List<String>.from(data['Story`s']);
                              }
                            }
                            RenderRepaintBoundary? boundary = widget
                                .contentKey.currentContext!
                                .findRenderObject()! as RenderRepaintBoundary;

                            ui.Image image =
                                await boundary.toImage(pixelRatio: 3.0);

                            ByteData? byteData = await image.toByteData(
                                format: ui.ImageByteFormat.png);
                            Uint8List pngBytes = byteData!.buffer.asUint8List();

                            // Upload the image to Firebase Storage
                            final firebase_storage.Reference storageRef =
                                firebase_storage.FirebaseStorage.instance
                                    .ref()
                                    .child('story');

                            final firebase_storage.UploadTask uploadTask =
                                storageRef
                                    .child(
                                        'image_${DateTime.now().millisecondsSinceEpoch}.png')
                                    .putData(pngBytes);

                            final firebase_storage.TaskSnapshot
                                storageSnapshot =
                                await uploadTask.whenComplete(() {});

                            final String imageUrl =
                                await storageSnapshot.ref.getDownloadURL();

                            // Add the new image URL to the existing list
                            existingImages.add(imageUrl);

                            // Update the document with the updated image list
                            await users.doc(userId).set(<String, dynamic>{
                              'Story`s': existingImages,
                            }, SetOptions(merge: true));

                            // Call the onDone callback with the image URL
                            widget.onDone(imageUrl);
                            _deleteStoriesAfterDelay(userId, [imageUrl]);
                            setState(() {
                              isLoading = false;
                            });
                            Get.back();
                          } catch (e) {
                            if (kDebugMode) {
                              print('Error uploading image: $e');
                            }
                          }
                        },
                        child: widget.onDoneButtonStyle ??
                            Container(
                              padding: const EdgeInsets.only(
                                left: 12,
                                right: 5,
                                top: 4,
                                bottom: 4,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    isLoading == true ? 'Loading...' : 'Share',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1.5,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 5),
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ),
                                ],
                              ),
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
    );
  }

  Widget _preViewContainer({child}) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 1.4, color: Colors.white),
      ),
      child: child,
    );
  }
}
