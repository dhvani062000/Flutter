import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/constant/assets_constant.dart';
import 'package:task/screen/auth/signin_screen.dart';


class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Stack(
        children: [
          // Background Illustration
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.network(
                  "https://thumbs.dreamstime.com/b/learning-foreign-language-colorful-illustration-learning-foreign-language-colorful-illustration-vector-language-learning-101752722.jpg",
                  fit: BoxFit.cover,
              )

            ),
          ),

          Center(
            child: FadeTransition(
              opacity: _fadeInAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Image.asset(AssetConstant.logo, width: 240, height: 160),
                  const SizedBox(height: 20),

                  Text(
                    "Choose Your Language".tr,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Language Buttons (Circular)
                  SlideTransition(
                    position: _slideAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildLanguageButton("English", "🇺🇸", const Locale('en', 'US')),
                        const SizedBox(width: 15),
                        _buildLanguageButton("हिन्दी", "🇮🇳", const Locale('hi', 'IN')),
                        const SizedBox(width: 15),
                        _buildLanguageButton("ગુજરાતી", "🇮🇳", const Locale('gu', 'IN')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **Circular Language Selection Button**
  Widget _buildLanguageButton(String language, String flag, Locale locale) {
    return GestureDetector(
      onTap: () {
        Get.updateLocale(locale);
        Get.off(() => const SigninScreen());
      },
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2), // Transparent white
              border: Border.all(color: Colors.white.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(child: Text(flag, style: const TextStyle(fontSize: 32))),
          ),
          const SizedBox(height: 8),
          Text(
            language,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
