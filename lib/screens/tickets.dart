import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/bottom_nav_bar.dart';
import '../providers/user_provider.dart';
import '../utils/global_colors.dart';
import 'dart:convert';
import '../models/dto/ReservationDto.dart';
import '../services/ReservationService.dart';

class Tickets extends StatefulWidget {
  const Tickets({super.key});

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  int _selectedIndex = 2;
  final ReservationService reservationService = ReservationService();
  bool isLoading = true;
  List<Reservation> myReservations = [];

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadMyReservations());
  }

  Future<void> _loadMyReservations() async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      if (user == null) return;
      final userId = user.jmbg;

      final reservations = await reservationService.getMyReservations(userId);
      setState(() {
        myReservations = reservations;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'reserved':
        return Colors.lightGreen;
      case 'confirmed':
        return Colors.lightBlue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final role = user.role;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.black, automaticallyImplyLeading: false,
        title: Text(
          role == 'ADMIN' ? 'Admin Panel' : 'My Tickets',
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background.jpg',
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
              color: Colors.black54,
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: role == 'ADMIN' ? _buildAdminView(context) : _buildClientView(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildAdminView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAdminCard(
            title: 'Check the Tickets',
            icon: Icons.qr_code_scanner,
            onTap: () {
              Navigator.pushNamed(context, '/camera');
            },
          ),
          const SizedBox(height: 30),
          _buildAdminCard(
            title: 'Projections',
            icon: Icons.people_outline,
            onTap: () {
              Navigator.pushNamed(context, '/add-projection');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildClientView() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (myReservations.isEmpty) {
      return const Center(
        child: Text(
          'Your Tickets',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: myReservations.length,
      itemBuilder: (context, index) {
        final reservation = myReservations[index];
        return GestureDetector(
            onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              backgroundColor: Colors.black87,
              content: reservation.qrCodeBase64 != null
                  ? Image.memory(
                base64Decode(reservation.qrCodeBase64!),
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              )
                  : const Icon(Icons.qr_code, color: Colors.white24, size: 250),
            ),
          );
        },
        child: Card(
          color: Colors.grey[900],
          margin: const EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reservation.filmTitle,
                        style: const TextStyle(
                            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${reservation.date} ${reservation.time}',
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Seat: ${reservation.seats.join(", ")}',
                        style: const TextStyle(color: Colors.white54),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top:10),
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: _getStatusColor(reservation.status),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          reservation.status,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 90,
                  height: 90,
                  child: reservation.qrCodeBase64 != null
                      ? Image.memory(
                    base64Decode(reservation.qrCodeBase64!),
                    fit: BoxFit.contain,
                  )
                      : const Icon(Icons.qr_code, color: Colors.white24, size: 80),
                ),
              ],
            ),
          ),
        ),
        );
      },
    );
  }

  Widget _buildAdminCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 320,
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
        decoration: BoxDecoration(
          color: GlobalColors.red,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
