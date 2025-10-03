import 'package:flutter/material.dart';
import '../models/dto/PaymentDto.dart';
import '../utils/global_colors.dart';

class PaymentOptionPage extends StatelessWidget {
  final PaymentDto paymentData;

  const PaymentOptionPage({super.key, required this.paymentData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Choose Payment',
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: GlobalColors.black,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.grey),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildPaymentCard(
              context,
              title: "Pay in person",
              color: Colors.grey[850]!,
              onTap: () => Navigator.pushReplacementNamed(context, '/tickets'),
            ),
            const SizedBox(height: 20),
            _buildPaymentCard(
              context,
              title: "Pay Online",
              color: GlobalColors.red,
              onTap: () => Navigator.pushNamed(
                context,
                '/online-payment',
                arguments: paymentData,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context,
      {required String title, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Colors.black54, blurRadius: 10, offset: Offset(0, 4)),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
