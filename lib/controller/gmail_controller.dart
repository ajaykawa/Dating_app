
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GmailController extends GetxController {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<GoogleSignInAccount?> _currentUser = Rx<GoogleSignInAccount?>(null);

  GoogleSignInAccount? get currentUser => _currentUser.value;

  @override
  void onInit() {
    super.onInit();
    _googleSignIn.onCurrentUserChanged.listen((event) {
      _currentUser.value = event;
    });
    _googleSignIn.signInSilently();
  }

  Future login() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    UserCredential? userCredential =
    await _auth.signInWithCredential(credential);
    User? user = userCredential.user;
    _currentUser.value = googleUser;
  }

  Future logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
    _currentUser.value = null;
  }
}
