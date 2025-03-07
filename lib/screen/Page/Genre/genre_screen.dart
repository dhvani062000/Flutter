import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/constant/color_constant.dart';
import 'package:task/project_specific/custom_appbar.dart';
import 'package:task/screen/Page/Genre/Movie/movie_home.dart';
import 'package:task/screen/Page/Genre/TV%20show/tvshow_home.dart';
import 'package:task/screen/Page/Genre/Videos/video_home.dart';
import 'package:task/screen/Page/Home/search_screen.dart';
import 'package:task/screen/Page/Profile/notification_screen.dart';
import 'package:task/screen/Page/Profile/profile.dart';

class GenreTab extends StatefulWidget {
  const GenreTab({super.key});

  @override
  State<GenreTab> createState() => _GenreTabState();
}

class _GenreTabState extends State<GenreTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: CustomAppBar(
          title: "STREAM PRIME",
          showIcons: true,
          onSearchTap: () => Get.to(() => SearchScreen()),
          onNotificationTap: () => Get.to(() => NotificationsScreen()),
          onProfileTap: () => Get.to(() => ProfileScreen()),
          bottom: TabBar(
            indicatorColor: ColorConstant.primary,
            labelColor: ColorConstant.whiteColor,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "movie".tr),
              Tab(text: "tv_show".tr),
              Tab(text: "video".tr),

            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MovieHomeScreen(),
            TvShowHomeScreen(),
            VideoHomeScreen(),
          ],
        ),
      ),
    );
  }
}
