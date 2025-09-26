import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/bottom_nav_bar.dart';
import '../providers/user_provider.dart';
import '../utils/global_colors.dart';
import '../widgets/global_navbar.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 3;

  late TextEditingController _phoneController;
  late TextEditingController _jmbgController;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    // _phoneController = TextEditingController(text: user?.MobileNumber ?? '');
    _jmbgController = TextEditingController(text: user?.jmbg ?? '');
  }

  void _onItemTapped(int index) {
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
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const NavBar(title: 'Profile', automaticallyImplyLeading:false ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          final user = userProvider.user;
          if (user == null) return const Center(child: CircularProgressIndicator());

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 16),
              child: Column(
                children: [
                  // Avatar and name
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 48,
                          backgroundColor: GlobalColors.red,
                          child: Text(
                            (user.name != null && user.surname != null)
                                ? '${user.name![0]}${user.surname![0]}'
                                : "",
                            style: const TextStyle(
                                fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          "${user.name ?? ''} ${user.surname ?? ''}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user.email ?? "",
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Divider(
                          color: Colors.white24,
                          thickness: 1,
                          endIndent: 24,
                          indent: 24,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.09),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        // _buildProfileField("Phone number", _phoneController.text, Icons.phone),
                        Divider(color: Colors.grey[700], height: 32),
                        _buildProfileField("JMBG", _jmbgController.text, Icons.credit_card),
                        // Add/Edit button if needed
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildProfileField(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: GlobalColors.red, size: 24),
        const SizedBox(width: 18),
        Expanded(
            child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                )
            )
        ),
      ],
    );
  }
}
