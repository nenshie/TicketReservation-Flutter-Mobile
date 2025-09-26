import 'package:flutter/material.dart';
import 'package:cinema_reservations_front/utils/global_colors.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    final String role = user?.role ?? 'Client';

    final bottomNavItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.movie_creation_outlined),
        activeIcon: Icon(Icons.movie_creation),
        label: 'Movies',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.calendar_today_outlined),
        activeIcon: Icon(Icons.calendar_today),
        label: 'Projection',
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.local_activity_outlined),
        activeIcon: const Icon(Icons.local_activity),
        label: role == 'ADMIN' ? 'Admin' : 'My Tickets',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      child: Container(
        decoration: BoxDecoration(
          color: GlobalColors.black,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 12,
              offset: const Offset(0, -6),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: GlobalColors.red,
          elevation: 0,
          currentIndex: widget.currentIndex,
          onTap: (index) {
            if (index != widget.currentIndex) {
              widget.onTap(index);
              switch (index) {
                case 0:
                  Navigator.pushReplacementNamed(context, '/home');
                  break;
                case 1:
                  Navigator.pushReplacementNamed(context, '/projections');
                  break;
                case 2:
                  Navigator.pushReplacementNamed(context,  '/tickets');
                  break;
                case 3:
                  Navigator.pushReplacementNamed(context, '/profile');
                  break;
              }
            }
          },
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          items: bottomNavItems,
        ),
      ),
    );
  }

}

