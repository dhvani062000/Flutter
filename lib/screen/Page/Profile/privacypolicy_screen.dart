import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  final List<Map<String, String>> _policySections = [
    {
      "title": "privacy_1".tr,
      "content": "privacy_1_content".tr
    },
    {
      "title": "privacy_2".tr,
      "content":"privacy_2_content".tr
    },
    {
      "title": "privacy_3".tr,
      "content":"privacy_3_content".tr
    },
    {
      "title": "privacy_4".tr,
      "content": "privacy_4_content".tr
    },
    {
      "title": "privacy_5".tr,
      "content": "privacy_5_content".tr
    },
    {
      "title": "privacy_6".tr,
      "content": "privacy_6_content".tr
    },
    {
      "title": "privacy_7".tr,
      "content": "privacy_7_content".tr
    },
    {
      "title": "privacy_8".tr,
      "content": "privacy_8_content".tr
    },
    {
      "title": "privacy_9".tr,
      "content": "privacy_9_content".tr
    },
    {
      "title": "privacy_10".tr,
      "content": "privacy_10_content".tr
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("privacy_1".tr),
        backgroundColor: Colors.black,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF141E30), Color(0xFF243B55)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildPrivacyPolicyList(),
        ),
      ),
    );
  }

  /// **Build Expandable Privacy Policy List**
  Widget _buildPrivacyPolicyList() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _policySections.map((section) {
          return _buildExpandableSection(section["title"]!, section["content"]!);
        }).toList(),
      ),
    );
  }

  /// **Expandable Section with Card UI**
  Widget _buildExpandableSection(String title, String content) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        iconColor: Colors.white,
        collapsedIconColor: Colors.white70,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              content,
              style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
