import 'package:flutter/material.dart';

class GenreMovieScreen extends StatelessWidget {
  final String genreName;

  const GenreMovieScreen({super.key, required this.genreName});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, String>>> genreMovies = {
      "Action": [
        {
          "title": "John Wick",
          "image": "https://image.tmdb.org/t/p/w500/rSPw7tgCH9c6NqICZef4kZjFOQ5.jpg",
          "year": "2014",
          "rating": "7.4",
          "genre": "Action, Thriller"
        },
        {
          "title": "Mad Max: Fury Road",
          "image": "https://image.tmdb.org/t/p/w500/q719jXXEzOoYaps6babgKnONONX.jpg",
          "year": "2015",
          "rating": "8.1",
          "genre": "Action, Adventure"
        },
        {
          "title": "Gladiator",
          "image": "https://image.tmdb.org/t/p/w500/8UlWHLMpgZm9bx6QYh0NFoq67TZ.jpg",
          "year": "2000",
          "rating": "8.5",
          "genre": "Action, Drama"
        },
      ],
      "Horror": [
        {
          "title": "The Conjuring",
          "image": "https://image.tmdb.org/t/p/w500/d5NXSklXo0qyIYkgV94XAgMIckC.jpg",
          "year": "2013",
          "rating": "7.5",
          "genre": "Horror, Thriller"
        },
        {
          "title": "It",
          "image": "https://image.tmdb.org/t/p/w500/7IiTTgloJzvGI1TAYymCfbfl3vT.jpg",
          "year": "2017",
          "rating": "7.3",
          "genre": "Horror, Drama"
        },
      ],
      "Sci-Fi": [
        {
          "title": "Interstellar",
          "image": "https://image.tmdb.org/t/p/w500/6KErczPBROQty7QoIsaa6wJYXZi.jpg",
          "year": "2014",
          "rating": "8.7",
          "genre": "Sci-Fi, Drama"
        },
        {
          "title": "Blade Runner 2049",
          "image": "https://image.tmdb.org/t/p/w500/wrIpEGQ8sQ9u6ByUMdrWcFlrrZ7.jpg",
          "year": "2017",
          "rating": "8.0",
          "genre": "Sci-Fi, Thriller"
        },
      ],
    };

    List<Map<String, String>> movies = genreMovies[genreName] ?? [];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("$genreName ", style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: movies.isNotEmpty
            ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return _buildMovieCard(movies[index]);
          },
        )
            : const Center(
          child: Text(
            "",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  /// **Movie Card with Details**
  Widget _buildMovieCard(Map<String, String> movie) {
    return GestureDetector(
      onTap: () {
        // Handle movie click (Navigate to Movie Detail Screen if needed)
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Background Movie Image
            Image.network(
              movie["image"]!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // Gradient Overlay for Text Visibility
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),

            // Movie Details Section
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Movie Title
                    Text(
                      movie["title"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Movie Rating & Year
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          movie["rating"]!,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const Spacer(),
                        Text(
                          movie["year"]!,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Genre
                    Text(
                      movie["genre"]!,
                      style: const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
