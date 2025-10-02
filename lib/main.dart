import 'dart:io';
import 'package:cinema_reservations_front/screens/camera.dart';
import 'package:cinema_reservations_front/screens/films.dart';
import 'package:cinema_reservations_front/screens/logIn.dart';
import 'package:cinema_reservations_front/screens/make_reservation.dart';
import 'package:cinema_reservations_front/screens/online_payment.dart';
import 'package:cinema_reservations_front/screens/payment_option.dart';
import 'package:cinema_reservations_front/screens/profile.dart';
import 'package:cinema_reservations_front/screens/sign_in.dart';
import 'package:cinema_reservations_front/screens/tickets.dart';
import 'package:flutter/material.dart';
import 'package:cinema_reservations_front/screens/welcome_screen.dart';
import 'package:cinema_reservations_front/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:cinema_reservations_front/providers/user_provider.dart';
import 'package:cinema_reservations_front/screens/projections.dart';
import 'package:cinema_reservations_front/screens/projection.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/home': (context) => const Home(),
        '/login': (context) => const Login(),
        '/signIn': (context) => const SignIn(),
        '/projections': (context) => const Projections(),
        '/makeReservation' : (context) => const MakeReservation(),
        '/profile': (context) => const Profile(),
        '/tickets': (context) => const Tickets(),
        '/camera' : (context) =>  QRScannerScreen(),
        '/films' : (context) => const FilmsScreen(),
        '/add-projection' : (context) => const AddProjectionScreen(),
        '/online-payment' : (context) => const OnlinePaymentPage()
      },
    );
  }
}
