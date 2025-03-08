import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  /// **Login Function (Returns User?)**
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ Save login state in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);

      return userCredential.user;
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  /// **Register Function (Creates new user and returns User?)**
  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ✅ Save login state in SharedPreferences after successful registration
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);

      return userCredential.user;
    } catch (e) {
      print("Signup Error: $e");
      return null;
    }
  }

  /// **Logout Function (Clears SharedPreferences & FirebaseAuth)**
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // ✅ Clear login state from SharedPreferences
    await prefs.setBool("isLoggedIn", false);

    // ✅ Sign out from FirebaseAuth
    await _auth.signOut();

    print("User Logged Out");
  }

  /// **Check if user is logged in (Returns true/false)**
  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isLoggedIn = prefs.getBool("isLoggedIn");

    User? user = _auth.currentUser;
    return isLoggedIn == true && user != null; // ✅ Check both SharedPreferences & FirebaseAuth
  }

  // ✅ Sign Out Function
  Future<void> signOut() async {
    try {
      // Sign out from FirebaseAuth
      await _auth.signOut();

      // Sign out from Google if user signed in using Google
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
    } catch (e) {
      print("Error signing out: $e");
      rethrow; // Re-throwing to handle errors outside
    }
  }

  /// **Get Currently Logged-in User (Returns User?)**
  User? getCurrentUser() {
    return _auth.currentUser; // ✅ Returns the current user if logged in
  }
}
