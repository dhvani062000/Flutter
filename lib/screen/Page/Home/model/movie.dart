class Movie {
  final String title;
  final String imageUrl;
  final String genre;
  final double rating;
  final String description;
  final String videoUrl;

  Movie({
    required this.title,
    required this.imageUrl,
    required this.genre,
    required this.rating,
    required this.description,
    required this.videoUrl,
  });

  // If using JSON, make sure it's included in fromJson method
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      imageUrl: json['imageUrl'],
      genre: json['genre'],
      rating: (json['rating'] as num).toDouble(),
      description: json['description'],
      videoUrl: json['videoUrl'] ?? '', // 🔹 Handle missing values safely
    );
  }
}
