import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/constant/assets_constant.dart';
import 'package:task/constant/color_constant.dart';
import 'package:task/project_specific/bottom_navigation.dart';
import 'package:task/project_specific/custom_button.dart';
import 'package:task/project_specific/textformfiled.dart';
import 'package:task/screen/auth/signup_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);
      Get.offAll(() => const BottomNavigationBarExample());
    } on FirebaseAuthException catch (e) {
      _showSnackbar(e.message ?? "Login failed");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _isLoading = false);
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);
      Get.offAll(() => const BottomNavigationBarExample());
    } catch (e) {
      _showSnackbar("Google Sign-In failed. Try again.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            /// **Animation**
            SizedBox(
              height: Get.height * 0.28,
              child: Lottie.asset(
                'assets/images/animations.json',
                width: Get.width * 0.7,
                fit: BoxFit.contain,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      /// **Email Input**
                      CustomTextField(
                        controller: _emailController,
                        title: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: Icons.email,
                        validator: (value) => value!.isEmpty ? "Enter a valid email" : null,
                      ),
                      SizedBox(height: Get.height * 0.02), // Added spacing

                      /// **Password Input**
                      CustomTextField(
                        controller: _passwordController,
                        title: 'Password',
                        hintText: 'Enter your password',
                        obscureText: _obscurePassword,
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (value) => value!.length < 6 ? "Password must be at least 6 characters" : null,
                      ),
                      SizedBox(height: Get.height * 0.03), // Added spacing

                      /// **Login Button**
                      CustomElevatedButton(
                        text: _isLoading ? "Loading..." : "Login",
                        backgroundColor: Colors.blueAccent,
                        onPressed: _isLoading ? () {} : _login,
                      ),
                      SizedBox(height: Get.height * 0.02), // Added spacing

                      /// **Google Sign-In Button**
                      GestureDetector(
                        onTap: _signInWithGoogle,
                        child: Container(
                          width: Get.width * 0.8,
                          padding: EdgeInsets.symmetric(vertical: Get.height * 0.015),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AssetConstant.google, height: Get.height * 0.03),
                              SizedBox(width: Get.width * 0.03),
                              Text(
                                "Continue with Google",
                                style: TextStyle(color: Colors.white, fontSize: Get.width * 0.045),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.02), // Added spacing

                      /// **Sign Up Link**
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? ", style: TextStyle(color: Colors.white)),
                          GestureDetector(
                            onTap: () => Get.to(() => const SignupScreen()),
                            child: const Text(
                              "Sign up",
                              style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Get.height * 0.03), // Added spacing
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
