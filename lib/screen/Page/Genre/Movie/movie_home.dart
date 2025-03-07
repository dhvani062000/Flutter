import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/screen/Page/Genre/Movie/genre_movie.dart';

class MovieHomeScreen extends StatefulWidget {
  const MovieHomeScreen({super.key});

  @override
  State<MovieHomeScreen> createState() => _MovieHomeScreenState();
}

class _MovieHomeScreenState extends State<MovieHomeScreen> {
  final List<Map<String, dynamic>> genres = [
    {"name": "action".tr, "colors": [Color(0xFF1B0000), Color(0xFF4A0404)]},
    {"name": "adventure".tr, "colors": [Color(0xFF002923), Color(0xFF00564D)]},
    {"name": "animation".tr, "colors": [Color(0xFF1C1C1C), Color(0xFF332F2E)]},
    {"name": "assassin".tr, "colors": [Color(0xFF101010), Color(0xFF2A2A2A)]},
    {"name": "drama".tr, "colors": [Color(0xFF1A0738), Color(0xFF3D1C5C)]},
    {"name": "horror".tr, "colors": [Color(0xFF000000), Color(0xFF191919)]},
    {"name": "sci-fi".tr, "colors": [Color(0xFF040D24), Color(0xFF0A1735)]},
    {"name": "thriller".tr, "colors": [Color(0xFF300000), Color(0xFF5A0000)]},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemCount: genres.length,
          itemBuilder: (context, index) {
            return _buildGenreCard(genres[index]);
          },
        ),
      ),
    );
  }

  Widget _buildGenreCard(Map<String, dynamic> genre) {
    return GestureDetector(
      onTap: () {
        Get.to(() => GenreMovieScreen(genreName: genre["name"]));
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: genre["colors"] as List<Color>,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.8),
              blurRadius: 12,
              spreadRadius: 2,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            genre["name"],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black54, blurRadius: 3)],
            ),
          ),
        ),
      ),
    );
  }
}
