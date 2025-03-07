import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/constant/color_constant.dart';
import 'package:task/project_specific/text_theme.dart';


class TermsConditionsScreen extends StatefulWidget {
  const TermsConditionsScreen({super.key});

  @override
  State<TermsConditionsScreen> createState() => _TermsConditionsScreenState();
}

class _TermsConditionsScreenState extends State<TermsConditionsScreen> {
  final List<Map<String, String>> _termsSections = [
    {
      "title": "terms_and_conditions".tr,
      "content": "terms_and_conditions_content".tr
    },
    {
      "title": "terms_1".tr,
      "content": "terms_1_content".tr
    },
    {
      "title": "terms_2".tr,
      "content": "terms_2_content".tr
    },
    {
      "title": "terms_3".tr,
      "content": "terms_3_content".tr
    },
    {
      "title": "terms_4".tr,
      "content": "terms_4_content".tr
    },
    {
      "title": "terms_5".tr,
      "content": "terms_5_content".tr
    },
    {
      "title": "terms_6".tr,
      "content": "terms_6_content".tr
    },
    {
      "title": "terms_7".tr,
      "content":"terms_7_content".tr
    },
    {
      "title": "terms_8".tr,
      "content": "terms_8_content".tr
    },
    {
      "title": "terms_9".tr,
      "content":"terms_9_content".tr
    },
    {
      "title": "terms_10".tr,
      "content":"terms_10_content".tr
    },
    {
      "title": "terms_11".tr,
      "content": "terms_11_content".tr
    },
    {
      "title": "terms_12".tr,
      "content": "terms_12_content".tr
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "terms_and_conditions".tr,
          style: AppTextTheme.bold.copyWith(color: ColorConstant.whiteColor),
        ),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF141E30), Color(0xFF243B55)], // Modern Dark Gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildTermsList(),
        ),
      ),
    );
  }

  /// **Build Expandable Terms List**
  Widget _buildTermsList() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _termsSections.map((section) {
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
