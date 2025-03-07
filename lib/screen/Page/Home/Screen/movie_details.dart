import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task/constant/color_constant.dart';
import 'package:task/project_specific/text_theme.dart';
import 'package:task/screen/Page/Home/Screen/video_screen.dart';
import 'package:task/screen/Page/Home/model/movie.dart';


class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackgroundBlurredImage(),
          _buildGradientOverlay(),
          _buildMovieContent(context),
        ],
      ),
    );
  }

  /// Background Image with Blur Effect
  Widget _buildBackgroundBlurredImage() {
    return Positioned.fill(
      child: Stack(
        children: [
          Image.network(
            movie.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.5),
              Colors.black.withOpacity(0.9),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 40, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildBackButton(),
          _buildMoviePoster(),
          _buildMovieDetails(),
          _buildFloatingPlayButton(context),
          _buildMovieDescription(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 10),
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          onPressed: () => Get.back(),
        ),
      ),
    );
  }

  Widget _buildMoviePoster() {
    return Hero(
      tag: movie.imageUrl,
      child: Container(
        width: 200,
        height: 300,
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.network(
            movie.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildMovieDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            movie.title,
            style: AppTextTheme.bold.copyWith(
              fontSize: 26,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildGenreTag(),
              const SizedBox(width: 12),
              _buildRating(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenreTag() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        movie.genre,
        style: AppTextTheme.regular.copyWith(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        const Icon(Icons.star, color: Colors.yellow, size: 18),
        const SizedBox(width: 4),
        Text(
          "${movie.rating.toString()}/10",
          style: AppTextTheme.regular.copyWith(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingPlayButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => VideoScreen(videoUrl: movie.videoUrl));
        },
        icon: const Icon(Icons.play_arrow, size: 28, color: Colors.white),
        label: const Text(
          "Play Movie",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: ColorConstant.primary,
      ),
    );
  }

  Widget _buildMovieDescription() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        movie.description,
        textAlign: TextAlign.center,
        style: AppTextTheme.regular.copyWith(
          fontSize: 16,
          color: Colors.white70,
        ),
      ),
    );
  }
}
