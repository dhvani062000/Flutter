import 'package:flutter/material.dart';

class GenreVideoScreen extends StatelessWidget {
  final String genreName;

  const GenreVideoScreen({super.key, required this.genreName});

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, String>>> genreTvShows = {
      "Action": [
        {
          "title": "Daredevil",
          "image": "https://image.tmdb.org/t/p/w500/7RyHsO4yDXtBv1zUU3mTpHeQ0d5.jpg",
          "year": "2015",
          "rating": "8.6",
          "genre": "Action, Crime"
        },
        {
          "title": "The Punisher",
          "image": "https://image.tmdb.org/t/p/w500/6Dbp8xTMW62viDjMYeTq5WpP8Bt.jpg",
          "year": "2017",
          "rating": "8.0",
          "genre": "Action, Thriller"
        },
        {
          "title": "Arrow",
          "image": "https://image.tmdb.org/t/p/w500/qUE5RrP52epGO6I9qQuIdKECf3E.jpg",
          "year": "2012",
          "rating": "7.5",
          "genre": "Action, Drama"
        },
      ],
      "Horror": [
        {
          "title": "Stranger Things",
          "image": "https://image.tmdb.org/t/p/w500/x2LSRK2Cm7MZhjluni1msVJ3wDF.jpg",
          "year": "2016",
          "rating": "8.7",
          "genre": "Horror, Sci-Fi"
        },
        {
          "title": "The Haunting of Hill House",
          "image": "https://image.tmdb.org/t/p/w500/suOPvWNQbdX4we0UljAhMx1mG2T.jpg",
          "year": "2018",
          "rating": "8.6",
          "genre": "Horror, Drama"
        },
      ],
      "Sci-Fi": [
        {
          "title": "Black Mirror",
          "image": "https://image.tmdb.org/t/p/w500/yGqXEFmHFSdI8bFEUETdf0zVklq.jpg",
          "year": "2011",
          "rating": "8.8",
          "genre": "Sci-Fi, Thriller"
        },
        {
          "title": "The Expanse",
          "image": "https://image.tmdb.org/t/p/w500/bCfH1kSykNukgqyyTIBwQKDxMQo.jpg",
          "year": "2015",
          "rating": "8.5",
          "genre": "Sci-Fi, Drama"
        },
      ],
    };

    List<Map<String, String>> tvShows = genreTvShows[genreName] ?? [];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("$genreName TV Shows", style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
        child: tvShows.isNotEmpty
            ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.7, // Adjusted for better alignment
          ),
          itemCount: tvShows.length,
          itemBuilder: (context, index) {
            return _buildTvShowCard(tvShows[index]);
          },
        )
            : const Center(
          child: Text(
            "No TV Shows available for this genre",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  /// **TV Show Card with Details**
  Widget _buildTvShowCard(Map<String, String> tvShow) {
    return GestureDetector(
      onTap: () {
        // Handle TV Show click (Navigate to TV Show Detail Screen if needed)
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Background TV Show Image
            Image.network(
              tvShow["image"]!,
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

            // TV Show Details Section
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
                    // TV Show Title
                    Text(
                      tvShow["title"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // TV Show Rating & Year
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          tvShow["rating"]!,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        const Spacer(),
                        Text(
                          tvShow["year"]!,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Genre
                    Text(
                      tvShow["genre"]!,
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
