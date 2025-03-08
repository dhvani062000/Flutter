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
import 'package:task/screen/auth/signin_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName(_nameController.text.trim());
        await user.reload();

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLoggedIn", true);

        Get.offAll(() => const BottomNavigationBarExample());
      }
    } on FirebaseAuthException catch (e) {
      _showErrorSnackbar(e.message ?? "Signup failed");
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

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool("isLoggedIn", true);
        Get.offAll(() => const BottomNavigationBarExample());
      }
    } on FirebaseAuthException catch (e) {
      _showErrorSnackbar(e.message ?? "Google Sign-In failed");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackbar(String message) {
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
                      CustomTextField(
                        controller: _nameController,
                        title: "Full Name",
                        hintText: "John Doe",
                        prefixIcon: Icons.person,
                        validator: (value) => value!.isEmpty ? "Enter your full name" : null,
                      ),
                      SizedBox(height: Get.height * 0.02),

                      CustomTextField(
                        controller: _emailController,
                        title: "Email",
                        hintText: "JohnDoe@gmail.com",
                        prefixIcon: Icons.email,
                        validator: (value) => value!.isEmpty || !value.contains("@") ? "Enter a valid email" : null,
                      ),
                      SizedBox(height: Get.height * 0.02),

                      CustomTextField(
                        controller: _passwordController,
                        title: "Password",
                        hintText: "******",
                        obscureText: _obscurePassword,
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (value) => value!.length < 6 ? "Password must be at least 6 characters" : null,
                      ),
                      SizedBox(height: Get.height * 0.02),

                      CustomTextField(
                        controller: _confirmPasswordController,
                        title: "Confirm Password",
                        hintText: "******",
                        obscureText: _obscureConfirmPassword,
                        prefixIcon: Icons.lock,
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off, color: Colors.white),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                        validator: (value) => value != _passwordController.text ? "Passwords do not match" : null,
                      ),
                      SizedBox(height: Get.height * 0.03),

                      CustomElevatedButton(
                        text: _isLoading ? "Loading..." : "Create Account",
                        backgroundColor: Colors.blueAccent,
                        onPressed: _isLoading ? () {} : _signup,
                      ),
                      SizedBox(height: Get.height * 0.02),

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
                      SizedBox(height: Get.height * 0.02),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account? ", style: TextStyle(color: Colors.white)),
                          GestureDetector(
                            onTap: () => Get.to(() => const SigninScreen()),
                            child: const Text("Sign In", style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      SizedBox(height: Get.height * 0.03),
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
