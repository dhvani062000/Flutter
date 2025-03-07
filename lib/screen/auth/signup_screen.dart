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
import 'package:task/project_specific/text_theme.dart';
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

  /// **Sign Up Function**
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
      _showErrorSnackbar(_getFirebaseErrorMessage(e.code));
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
        return; // User canceled login
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
      _showErrorSnackbar(_getFirebaseErrorMessage(e.code));
    } catch (e) {
      _showErrorSnackbar("Google Sign-In failed. Try again.");
    } finally {
      setState(() => _isLoading = false);
    }
  }


  /// **Firebase Error Messages**
  String _getFirebaseErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return "This email is already in use.";
      case 'weak-password':
        return "Password must be at least 6 characters.";
      case 'invalid-email':
        return "Invalid email format.";
      case 'network-request-failed':
        return "Check your internet connection.";
      default:
        return "An error occurred. Please try again.";
    }
  }

  /// **Snackbar for Errors**
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              SizedBox(
                height: 200,
                child: Lottie.asset(
                  'assets/images/animations.json',
                  width: 400,
                  fit: BoxFit.fill,
                ),
              ),
              Form(
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
                    CustomTextField(
                      controller: _emailController,
                      title: "Email",
                      hintText: "JohnDoe@gmail.com",
                      prefixIcon: Icons.email,
                      validator: (value) => value!.isEmpty || !value.contains("@") ? "Enter a valid email" : null,
                    ),
                    CustomTextField(
                      controller: _passwordController,
                      title: "Password",
                      hintText: "******",
                      obscureText: _obscurePassword,
                      prefixIcon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                      validator: (value) => value!.length < 6 ? "Password must be at least 6 characters" : null,
                    ),
                    CustomTextField(
                      controller: _confirmPasswordController,
                      title: "Confirm Password",
                      hintText: "******",
                      obscureText: _obscureConfirmPassword,
                      prefixIcon: Icons.lock,
                      suffixIcon: IconButton(
                        icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                      validator: (value) => value != _passwordController.text ? "Passwords do not match" : null,
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : CustomElevatedButton(
                      text: "Create Account",
                      backgroundColor: ColorConstant.primary,
                      onPressed: _signup,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: _signInWithGoogle,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(AssetConstant.google, height: 24),
                            const SizedBox(width: 10),
                            Text("Sign in with Google", style: AppTextTheme.regular.copyWith(color: ColorConstant.blackColor)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account? "),
                        GestureDetector(
                          onTap: () => Get.to(() => const SigninScreen()),
                          child: const Text("Sign In", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
