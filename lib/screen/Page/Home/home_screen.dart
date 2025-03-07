import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:task/constant/color_constant.dart';
import 'package:task/project_specific/custom_appbar.dart';
import 'package:task/project_specific/text_theme.dart';
import 'package:task/screen/Page/Home/Screen/movie_details.dart';
import 'package:task/screen/Page/Home/model/movie.dart';
import 'package:task/screen/Page/Home/movie_screen.dart';
import 'package:task/screen/Page/Home/search_screen.dart';
import 'package:task/screen/Page/Home/tvshow_screen.dart';
import 'package:task/screen/Page/Home/video_screen.dart';
import 'package:task/screen/Page/Profile/notification_screen.dart';
import 'package:task/screen/Page/Profile/profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int _currentIndex = 0;

  final List<String> imageList = [
    'https://webartdevelopers.com/blog/wp-content/uploads/2018/12/fancy-slider.png',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZxBIwemN0Qqilz4etnzD5hpbVqbRBsJHWNA&s',
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcREDRvMfKQQycMI4xmR-1SyHh969BPF7zwSwA&s",
    'https://webartdevelopers.com/blog/wp-content/uploads/2018/12/fancy-slider.png',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZxBIwemN0Qqilz4etnzD5hpbVqbRBsJHWNA&s',
  ];

  final List<Widget> _screens = [
    const Placeholder(),
    const MovieScreen(),
    const TvshowScreen(),
    const VideosScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _screens[0] = _buildHomeTab();
  }

  void _onPageChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: "STREAM PRIME",
        showIcons: true,
        onSearchTap: () => Get.to(() => const SearchScreen()),
        onNotificationTap: () => Get.to(() => const NotificationsScreen()),
        onProfileTap: () => Get.to(() => const ProfileScreen()),
      ),
      body: _screens[_selectedIndex], // Display selected screen
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: ColorConstant.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: "Movies"),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: "TV Shows"),
          BottomNavigationBarItem(icon: Icon(Icons.video_collection), label: "Videos"),
        ],
      ),
    );
  }

  Widget _buildHomeTab() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          ImageSlider(
            imageList: imageList,
            currentIndex: _currentIndex,
            onPageChanged: _onPageChanged,
          ),
          const SizedBox(height: 20),
          _buildSectionTitle("🔥 Trending Now"),
          _buildHorizontalList(),
          const SizedBox(height: 20),
          _buildSectionTitle("🎬 Top 10 Picks"),
          _buildHorizontalList(),
          const SizedBox(height: 20),
          _buildSectionTitle("⭐ Recommended for You"),
          _buildHorizontalList(),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: AppTextTheme.bold.copyWith(
          fontSize: 22,
          color: ColorConstant.whiteColor,
        ),
      ),
    );
  }

  Widget _buildHorizontalList() {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: imageList.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Movie selectedMovie = Movie(
                title: "Movie Title $index",
                description: "This is a sample movie description.",
                imageUrl: imageList[index],
                genre: "Action",
                rating: 8.5, videoUrl: 'https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4',
              );
              Get.to(() => MovieDetailsScreen(movie: selectedMovie));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageList[index],
                  width: 110,
                  height: 130,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}

/// **Extracted Image Slider for Performance Optimization**
class ImageSlider extends StatelessWidget {
  final List<String> imageList;
  final int currentIndex;
  final Function(int, CarouselPageChangedReason) onPageChanged;

  const ImageSlider({
    Key? key,
    required this.imageList,
    required this.currentIndex,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            height: 270,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.85,
            autoPlayCurve: Curves.easeInOut,
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            onPageChanged: onPageChanged,
          ),
          itemCount: imageList.length,
          itemBuilder: (context, index, realIndex) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Stack(
                children: [
                  Image.network(
                    imageList[index],
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        Positioned(
          bottom: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: AnimatedSmoothIndicator(
              activeIndex: currentIndex,
              count: imageList.length,
              effect: ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                spacing: 5,
                activeDotColor: ColorConstant.primary,
                dotColor: Colors.grey.shade700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
