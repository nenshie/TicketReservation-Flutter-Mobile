import 'package:cinema_reservations_front/components/bottom_nav_bar.dart';
import 'package:cinema_reservations_front/models/dto/ProjectoinDto.dart';
import 'package:cinema_reservations_front/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/ProjectionService.dart';

class Projections extends StatefulWidget {
  const Projections({super.key});

  @override
  State<Projections> createState() => _ProjectionsState();
}

class _ProjectionsState extends State<Projections> {
  final int _currentIndex = 1;
  late Future<List<Projection>> _projectionsFuture;

  @override
  void initState() {
    super.initState();
    _projectionsFuture = ProjectionService().fetchAllProjections();
  }

  void _onNavBarTap(int index) {
    if (index != _currentIndex) {
      switch (index) {
        case 0:
          Navigator.pushReplacementNamed(context, '/home');
          break;
        case 1:
          break;
        case 2:
          Navigator.pushReplacementNamed(context, '/tickets');
          break;
        case 3:
          Navigator.pushReplacementNamed(context, '/profile');
          break;
      }
    }
  }

  String formatDuration(int minutes) {
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

  // String formatProjectionDateTime(String rawDate, String rawTime) {
  //   try {
  //     final date = DateTime.parse(rawDate);
  //     final time = DateTime.parse(rawTime);
  //
  //     final formattedDate = '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  //     final formattedTime = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  //
  //     return '📅 $formattedDate\n🕒 $formattedTime';
  //   } catch (e) {
  //     return '$rawDate $rawTime';
  //   }
  // }

  String formatProjectionDateTime(DateTime dateTime) {
    final formattedDate =
        '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
    final formattedTime =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    return '📅 $formattedDate\n🕒 $formattedTime';
  }

  Widget buildFilmCard(Projection projection) {
      final userProvider = Provider.of<UserProvider>(context);
      final user = userProvider.user;
      final String role = user?.role ?? 'Client';

      Widget card = Card(
        color: Colors.grey[900],
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SizedBox(
          height: 140,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                child: Image.network(
                  projection.film.posterUrl,
                  width: 100,
                  height: 140,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 140,
                      color: Colors.grey.shade800,
                      child: const Icon(Icons.broken_image, color: Colors.white),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        projection.film.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatDuration(projection.film.duration),
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Row za datum/vreme i cenu
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  formatProjectionDateTime(projection.dateTime),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              Text(
                                '💰 ${projection.price.toStringAsFixed(2)} RSD',
                                style: const TextStyle(
                                  color: Colors.orangeAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

      if (role != 'ADMIN') {
        card = GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              '/makeReservation',
              arguments: projection,
            );
          },
          child: card,
        );
      }

      return card;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
            "Projections",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,

        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Projection>>(
        future: _projectionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}",
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No films available",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final films = snapshot.data!;
          return ListView.builder(
            itemCount: films.length,
            itemBuilder: (context, index) {
              return buildFilmCard(films[index]);
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
