import 'package:cinema_reservations_front/utils/global_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class NavBar extends StatefulWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;
  final String title;

  const NavBar({
    super.key,
    this.automaticallyImplyLeading = false,
    required this.title,
  });

  @override
  State<NavBar> createState() => _NavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(40.0);
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      centerTitle: true,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      title: Text(
        widget.title,
        style: TextStyle(
          color: GlobalColors.red,
          fontSize: 25,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout, color: GlobalColors.red),
          onPressed: () {
            Provider.of<UserProvider>(context, listen: false).logout();
            Navigator.pushReplacementNamed(context, '/login');
          },
        ),
      ],
    );
  }
}
