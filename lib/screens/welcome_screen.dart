import 'package:flutter/material.dart';
import 'package:cinema_reservations_front/utils/global_colors.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(30),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/cineflix-logo.jpg"),
            fit: BoxFit.cover,
            opacity: 0.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "WELCOME TO",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "CINEFLIX",
              style: TextStyle(
                color: GlobalColors.red,
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your gateway to unlimited movies.\nPick. Reserve. Enjoy.",
              style: TextStyle(
                color: Colors.white60,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: GlobalColors.red,
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: GlobalColors.darkGrey,
                    side: BorderSide(color: GlobalColors.darkGrey),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 32,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/signIn');
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}