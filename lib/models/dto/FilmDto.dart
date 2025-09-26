import 'package:cinema_reservations_front/models/dto/GenreDto.dart';

class Film {
  final int filmId;
  final String title;
  final String posterUrl;
  final int duration;
  final Genre genre;

  Film({
    required this.filmId,
    required this.title,
    required this.posterUrl,
    required this.duration,
    required this.genre,
  });

  factory Film.fromJson(Map<String, dynamic> json) {
    return Film(
      filmId: json['filmId'],
      title: json['title'] ?? 'Unknown Title',
      posterUrl: json['posterUrl'] ?? '',
      duration: json['duration'] ?? 0,
      genre: Genre(
        genreId: json['genreId'],
        name: json['genreName'] ?? 'Unknown Genre',
      ),
    );
  }
}
