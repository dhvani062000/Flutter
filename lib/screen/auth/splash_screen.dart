import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task/constant/assets_constant.dart';
import 'package:task/project_specific/bottom_navigation.dart';
import 'package:task/screen/auth/language_screen.dart';
import 'package:task/screen/auth/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _controller.forward();

    /// **Check Authentication Status After Splash Delay**
    Future.delayed(const Duration(seconds: 3), _checkUserStatus);
  }

  /// **Check User Login Status**
  Future<void> _checkUserStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false; // Default to false

    User? user = FirebaseAuth.instance.currentUser;

    if (isLoggedIn && user != null) {
      /// ✅ **User is logged in, go to Home**
      Get.off(() => const BottomNavigationBarExample(), transition: Transition.fadeIn);
    } else {
      /// ❌ **User is logged out, go to Login**
      Get.off(() => const LanguageSelectionScreen(), transition: Transition.fadeIn);
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF141E30), Color(0xFF243B55)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Image.asset(
                    AssetConstant.logo,
                    width: 180,
                    height: 180,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
