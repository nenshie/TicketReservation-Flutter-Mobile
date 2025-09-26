import 'package:flutter/material.dart';

class MovieCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final String duration;

  const MovieCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.duration,
  });

  String formatDuration(String durationInMinutes) {
    final minutes = int.tryParse(durationInMinutes) ?? 0;
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0 && remainingMinutes > 0) {
      return '${hours}h ${remainingMinutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${remainingMinutes}m';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imagePath,
            width: 160,
            height: 250,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 160,
                height: 250,
                color: Colors.grey.shade800,
                child: const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.access_time,
                  color: Colors.white70,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  formatDuration(duration),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 255,
          left: 8,
          right: 8,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(blurRadius: 2, color: Colors.black)],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
