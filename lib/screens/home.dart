import 'package:flutter/material.dart';
import 'package:cinema_reservations_front/components/movie_card.dart';
import 'package:cinema_reservations_front/utils/global_colors.dart';
import 'package:cinema_reservations_front/components/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/global_navbar.dart';
import '../services/FilmService.dart';
import '../models/dto/FilmDto.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final int _currentIndex = 0;
  late Future<List<Film>> _filmsFuture;

  @override
  void initState() {
    super.initState();
    _filmsFuture = FilmService.fetchAllFilms(size: 5);
  }

  void _onNavBarTap(int index) {
    if (index != _currentIndex) {
      switch (index) {
        case 0:
          break;
        case 1:
          Navigator.pushReplacementNamed(context, '/projections');
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

  Widget _buildFilmList(List<Film> films) {
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        itemCount: films.length,
        itemBuilder: (context, index) {
          final film = films[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: MovieCard(
              title: film.title,
              imagePath: film.posterUrl,
              duration: film.duration.toString(),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    final userName = user != null ? '${user.name} ${user.surname}' : 'User';

    return Scaffold(
      backgroundColor: GlobalColors.black,
      appBar: const NavBar(title: 'CINEFLIX'),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                child: Text(
                  "Hello, $userName",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Now Showing",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              FutureBuilder<List<Film>>(
                future: _filmsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
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
                  return _buildFilmList(snapshot.data!);
                },
              ),

              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  "Top Rated",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              FutureBuilder<List<Film>>(
                future: _filmsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
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
                  return _buildFilmList(snapshot.data!);
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
