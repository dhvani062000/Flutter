import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:task/constant/color_constant.dart';
import 'package:task/project_specific/custom_appbar.dart';
import 'package:task/project_specific/text_theme.dart';
import 'package:task/screen/Page/Profile/helpcenter_screen.dart';
import 'package:task/screen/Page/Profile/movie_screen.dart';
import 'package:task/screen/Page/Profile/notification_screen.dart';
import 'package:task/screen/Page/Profile/privacypolicy_screen.dart';
import 'package:task/screen/Page/Profile/terms&condition_screen.dart';
import 'package:task/screen/auth/signin_screen.dart';
import 'package:task/utils/auth_service.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  File? _profileImage;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  /// **Fetch Logged-in User from Firebase**
  void _getCurrentUser() {
    _user = _auth.currentUser;
    _nameController.text = _user?.displayName ?? "User Name";
    _emailController.text = _user?.email ?? "user000@gmail.com";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.blackColor,
      appBar: CustomAppBar(
        title: "STREAM PRIME",
        showIcons: true,
        onSearchTap: () {},
        onNotificationTap: () => Get.to(() => const NotificationsScreen()),
        onProfileTap: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 20),
            _buildSectionTitle("manage_account".tr),
            const SizedBox(height: 10),
            _buildLanguageSelector(),
            _buildProfileOption(Icons.playlist_add, "playlists".tr, () => Get.to(() => const MoviesScreen())),
            _buildProfileOption(Icons.notifications, "notifications".tr, () => Get.to(() => const NotificationsScreen())),
            _buildProfileOption(Icons.note_add_sharp, "terms_and_conditions".tr, () => Get.to(() => const TermsConditionsScreen())),
            _buildProfileOption(Icons.security, "privacy_1".tr, () => Get.to(() => const PrivacyPolicyScreen())),
            _buildProfileOption(Icons.help, "help_center".tr, () => Get.to(() => const HelpCenterScreen())),
            _buildProfileOption(Icons.logout_outlined, "sign_out".tr, () => _confirmSignOut(context), isLogout: true),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }


  /// **Builds Profile Header Section**
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF141E30), Color(0xFF243B55)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: _showImagePickerDialog,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!) as ImageProvider
                      : const NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSteItzPyeDKBxyWiOA8xrPZXIlxOYv1b1VVg&s",
                  ),
                ),
                const CircleAvatar(
                  radius: 14,
                  backgroundColor: Colors.black54,
                  child: Icon(Icons.camera_alt, color: Colors.white, size: 16),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _user?.displayName ?? "User Name",
              style: AppTextTheme.bold.copyWith(
                color: ColorConstant.whiteColor,
                fontSize: 22,
              ),
            ),
            Text(
              _user?.email ?? "user000@gmail.com",
              style: AppTextTheme.medium.copyWith(
                color: ColorConstant.greyColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
          IconButton(
            onPressed: _editProfile,
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }

  /// **Title for Each Section**
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: AppTextTheme.bold.copyWith(color: ColorConstant.whiteColor, fontSize: 18),
      ),
    );
  }

  /// **Show Dialog to Pick Image from Camera or Gallery**
  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.white),
              title: const Text("Take a Photo", style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.white),
              title: const Text("Choose from Gallery", style: TextStyle(color: Colors.white)),
              onTap: () {
                Get.back();
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  /// **Function to Pick Image from Gallery or Camera**
  void _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    } else {
      print("No image selected");
    }
  }

  /// **Profile Option with ListTile**
  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return Card(
      color: isLogout ? Colors.redAccent : Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          title,
          style: AppTextTheme.medium.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_outlined, color: Colors.white38),
        onTap: onTap,
      ),
    );
  }

  /// **Edit Profile Dialog**
  void _editProfile() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Profile"),
          backgroundColor: Colors.grey[900],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: _nameController, decoration: const InputDecoration(labelText: "Name")),
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: "Email")),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("Cancel", style: TextStyle(color: Colors.white70))),
            TextButton(
              onPressed: () {
                setState(() {});
                Get.back();
              },
              child: const Text("Save", style: TextStyle(color: Colors.blueAccent)),
            ),
          ],
        );
      },
    );
  }

  /// **Language Selection Button**
  Widget _buildLanguageSelector() {
    List<Locale> availableLocales = [
      const Locale('en', 'US'),
      const Locale('hi', 'IN'),
      const Locale('gu', 'IN'),
    ];

    // Ensure Get.locale is in availableLocales, else default to English
    Locale currentLocale = availableLocales.contains(Get.locale)
        ? Get.locale!
        : availableLocales.first;

    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: ListTile(
        leading: const Icon(Icons.language, color: Colors.white),
        title: Text(
          "Language".tr,
          style: AppTextTheme.medium.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        trailing: DropdownButtonHideUnderline(
          child: DropdownButton<Locale>(
            dropdownColor: Colors.grey[850],
            value: currentLocale, // Ensure this is valid
            icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            onChanged: (Locale? newLocale) {
              if (newLocale != null) {
                Get.updateLocale(newLocale);
              }
            },
            items: availableLocales.map((locale) {
              return DropdownMenuItem(
                value: locale,
                child: Text(
                  locale.languageCode == 'en' ? "English" :
                  locale.languageCode == 'hi' ? "हिन्दी" : "ગુજરાતી",
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// **Sign Out Confirmation**
  /// **Sign Out Confirmation Dialog with Modern UI**
  void _confirmSignOut(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, _, __) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.grey[900], // Dark theme background
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.logout, color: Colors.redAccent, size: 50),
                const SizedBox(height: 15),
                Text(
                  "sign_out".tr,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  "confirm_sign_out".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Get.back(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700],
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text("cancel".tr, style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Get.back(); // ✅ Close the dialog
                        _signOutUser(); // ✅ Call logout function
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text("sign_out".tr, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          child: child,
        );
      },
    );
  }

  void _signOutUser() async {
    try {
      final AuthService _authService = AuthService();


      // Navigate to Login Screen
      Get.offAll(() => const SigninScreen());

      print("User has been logged out successfully.");
    } catch (e) {
      print("Error during logout: $e");
      Get.snackbar(
        "Logout Failed",
        "Something went wrong. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

}
