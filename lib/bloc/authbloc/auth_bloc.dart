import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Screens/gender_screen.dart';
import '../../Screens/user_details.dart';
import '../../auth/otp_screen.dart';
import '../../const.dart';
import '../../utils/navigationbar.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignUpUsingMobileNumber>(_signUpUsingPhone);
    on<OtpVerification>(_OtpVerify);
    on<SaveUserDetails>(_SaveUserDetailInFirebase);
    on<SaveGender>(_saveSelectedGender);
    on<SaveInterests>(_SaveInterests);
    on<SaveAboutMe>(_SaveAboutMe);
    on<SaveRelationShipGoal>(_SaveRelationGoals);
    on<SaveRelationShipType>(_SaveRelaitonType);
    on<SaveLanguages>(_SaveLanguages);
    on<SaveSelectedPet>(_SavePetSelected);
    on<SaveDrinkingHabits>(_SaveDrinkingHabits);
    on<SaveSmokingHabits>(_SaveSmokingHabits);
    on<SaveDietPreferences>(_SaveDietPrefs);
    on<SaveJobTitle>(_SaveJotTitle);
    on<SaveCompanyName>(_SaveCompanyName);
    on<SaveEducation>(_SaveEducation);
  }

//----------------------------------------------------------------------------------------------------------------------------------------------------------
  void _signUpUsingPhone(
      SignUpUsingMobileNumber event,
      Emitter<AuthState> emit,
      ) async {
    emit(AuthLoading());

    try {
      final PhoneVerificationCompleted verificationCompleted =
          (AuthCredential credential) async {
        emit(AuthLoaded());
        await FirebaseAuth.instance.signInWithCredential(credential);
        // Navigate to the main screen
        // Example: Get.offAll(MainScreen());
      };

      verificationFailed(FirebaseAuthException e) {
        debugPrint('Error verifying phone number: ${event.countyCode}${event.phoneNumber}, error: ${e.message}');
        Get.snackbar(
          'Error',
          'Failed to verify phone number',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }

      codeSent(String verificationId, int? resendToken) async {
          await Get.to(() => OtpScreen(
            verificationId: verificationId,
            resendToken: resendToken,
            phoneNumber: event.phoneNumber,
            countryCode: event.countyCode,
          ));
        emit(codeSent(verificationId, resendToken));
      };

      codeAutoRetrievalTimeout(String verificationId) {
        if (kDebugMode) {
          print('codeAutoRetrievalTimeout: $verificationId');
        }
        emit(codeAutoRetrievalTimeout(verificationId));
        AuthError();
      }

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: event.phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      debugPrint('Error verifying phone number: ${event.countyCode}, error: $e');
      Get.snackbar(
        'Error',
        'Failed to verify phone number',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      emit(AuthError());
    }
  }

//----------------------------------------------------------------------------------------------------------------------------------------------------------
  void _OtpVerify(
    OtpVerification event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: event.verificationId,
        smsCode: event.otpsent,
      );
      emit(AuthLoaded());
      await FirebaseAuth.instance.signInWithCredential(credential);
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        if (userDoc.exists == currentUser.uid) {
          Get.offAll(MyNavigationBar(i: 3,)); // navigate to the main screen
        } else {
          Get.to(const UserDetails()); // navigate to the user details screen
        }
      } else {
        errorSnackbar("Invalid user credentials"); // show error message
        emit(AuthError());
      }
    } on FirebaseAuthException catch (e) {
      errorSnackbar("Please Input Valid Otp");
      emit(AuthError());
    }
  }

//----------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> _SaveUserDetailInFirebase(
    SaveUserDetails event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    if (event.user.isNotEmpty) {
      final firebaseAuth = FirebaseAuth.instance;
      final firebaseUser = firebaseAuth.currentUser;
      final userId = firebaseUser!.uid;
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(userId);
final token = FirebaseMessaging.instance.getToken();
      emit(AuthLoaded());
      await userRef.set({
        'username': event.user,
        'UID': userId,
        'mychats': [],
        'devicetoken': '$token',
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', userId);

      Get.to(() => const MaleFemale());
    } else {
      if (event.user.isEmpty) {
        Get.snackbar("Username", "Please Enter Your Username");
      }
      emit(AuthError());
    }
  }

//-----------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> _saveSelectedGender(
      SaveGender event, Emitter<AuthState> emit) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser =  firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user = users.doc(userId);

    await user.set(<String, dynamic>{
      'gender': event.gender,
    }, SetOptions(merge: true));
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> _SaveInterests(
      SaveInterests event, Emitter<AuthState> emit) async {
    if (event.allinterests.length >= 5) {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final firebaseAuth = FirebaseAuth.instance;
      final firebaseUser =  firebaseAuth.currentUser;
      final userId = firebaseUser!.uid;
      final DocumentReference user = users.doc(userId);
      await user.set(<String, dynamic>{
        'Interests': event.allinterests,
      }, SetOptions(merge: true));
      Get.to(MyNavigationBar(i: 3,));
    } else {
      errorSnackbar("Select Atleast 5 interests!");
    }
  }

//-----------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> _SaveAboutMe(SaveAboutMe event, Emitter<AuthState> emit) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser =  firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user = users.doc(userId);
    await user.set(
        {'about_me': event.aboutme},
        SetOptions(
          merge: true,
        ));
  }

//-----------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> _SaveRelationGoals(
      SaveRelationShipGoal event, Emitter<AuthState> emit) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = await firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user = users.doc(userId);
    await user
        .set({'RelaitonShip Goal': event.reltngoals}, SetOptions(merge: true));
    Future<void> GetGoal() async {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final firebaseAuth = FirebaseAuth.instance;
      final firebaseUser = await firebaseAuth.currentUser;
      final userId = firebaseUser!.uid;
      final DocumentReference user = users.doc(userId);

// Retrieve data from Firebase
      final DocumentSnapshot snapshot = await user.get();
      final goalsrelation = snapshot.get('RelaitonShip Goal');
    }
  }

//-----------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> _SaveRelaitonType(
      SaveRelationShipType event, Emitter<AuthState> emit) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = await firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user = users.doc(userId);
    await user.set(
        {'RelaitonShip Type': event.relationtype}, SetOptions(merge: true));
    Future<void> GetRelation() async {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final firebaseAuth = FirebaseAuth.instance;
      final firebaseUser = await firebaseAuth.currentUser;
      final userId = firebaseUser!.uid;
      final DocumentReference user = users.doc(userId);

// Retrieve data from Firebase
      final DocumentSnapshot snapshot = await user.get();
      final relation = snapshot.get('RelaitonShip Type');
    }
  }

//----------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> _SaveLanguages(
      SaveLanguages event, Emitter<AuthState> emit) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = await firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user = users.doc(userId);
    await user.set(<String, dynamic>{
      'Languages': event.languages,
    }, SetOptions(merge: true));
  }

//------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> _SavePetSelected(
      SaveSelectedPet event, Emitter<AuthState> emit) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = await firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user = users.doc(userId);
    await user.set({'Pets Like': event.pet}, SetOptions(merge: true));
    Future<void> GetPets() async {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final firebaseAuth = FirebaseAuth.instance;
      final firebaseUser = await firebaseAuth.currentUser;
      final userId = firebaseUser!.uid;
      final DocumentReference user = users.doc(userId);

// Retrieve data from Firebase
      final DocumentSnapshot snapshot = await user.get();
      final petsSelected = snapshot.get('Pets Like');
    }
  }

//--------------------------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> _SaveDrinkingHabits(
      SaveDrinkingHabits event, Emitter<AuthState> emit) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = await firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user = users.doc(userId);
    await user
        .set({'Drinking Habits': event.drinkinghabit}, SetOptions(merge: true));
    Future<void> GetDrink() async {
      final CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      final firebaseAuth = FirebaseAuth.instance;
      final firebaseUser = await firebaseAuth.currentUser;
      final userId = firebaseUser!.uid;
      final DocumentReference user = users.doc(userId);

// Retrieve data from Firebase
      final DocumentSnapshot snapshot = await user.get();
      final drinkinghabit = snapshot.get('Drinking Habits');
    }
  }

  //------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> _SaveSmokingHabits(
      SaveSmokingHabits event, Emitter<AuthState> emit) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = await firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user = users.doc(userId);
    await user
        .set({'Smoking Habits': event.smokinghabits}, SetOptions(merge: true));
    Get.back();
  }

  Future<void> GetData() async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = await firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user = users.doc(userId);

// Retrieve data from Firebase
    final DocumentSnapshot snapshot = await user.get();
    final smokingHabits = snapshot.get('Smoking Habits');
  }

//------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> _SaveDietPrefs(
      SaveDietPreferences event, Emitter<AuthState> emit) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = await firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user = users.doc(userId);
    await user.set(
        {'Diet Preferences': event.dietpreferences}, SetOptions(merge: true));
  }

//------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> _SaveJotTitle(
      SaveJobTitle event, Emitter<AuthState> emit) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = await firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user = users.doc(userId);
    await user.set({'Job Title': event.jobtitle}, SetOptions(merge: true));
  }

//------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> _SaveCompanyName(
      SaveCompanyName event, Emitter<AuthState> emit) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = await firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user = users.doc(userId);
    await user
        .set({'Company Name': event.companyname}, SetOptions(merge: true));
  }

//------------------------------------------------------------------------------------------------------------------------------------------
  Future<void> _SaveEducation(
      SaveEducation event, Emitter<AuthState> emit) async {
    final CollectionReference users =
        FirebaseFirestore.instance.collection('users');
    final firebaseAuth = FirebaseAuth.instance;
    final firebaseUser = await firebaseAuth.currentUser;
    final userId = firebaseUser!.uid;
    final DocumentReference user = users.doc(userId);
    await user.set({'Education': event.education}, SetOptions(merge: true));
  }
}
