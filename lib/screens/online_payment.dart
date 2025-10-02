import 'package:flutter/material.dart';
import '../models/dto/PaymentDto.dart';
import '../services/ReservationService.dart';
import '../utils/global_colors.dart';

class OnlinePaymentPage extends StatefulWidget {
  const OnlinePaymentPage({super.key});

  @override
  State<OnlinePaymentPage> createState() => _OnlinePaymentPageState();
}

class _OnlinePaymentPageState extends State<OnlinePaymentPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();

  bool isLoading = false;
  final ReservationService reservationService = ReservationService();

  @override
  Widget build(BuildContext context) {
    final paymentData =
        ModalRoute.of(context)!.settings.arguments as PaymentDto;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Online Payment'),
        backgroundColor: GlobalColors.black,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset("assets/online_pay.jpg", fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.7)),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[900]?.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${paymentData.movieTitle}\n"
                        "Date: ${paymentData.dateTime.day.toString().padLeft(2, '0')}.${paymentData.dateTime.month.toString().padLeft(2, '0')}.${paymentData.dateTime.year} "
                        "at ${paymentData.dateTime.hour.toString().padLeft(2, '0')}:${paymentData.dateTime.minute.toString().padLeft(2, '0')}\n\n"
                        "Tickets: ${paymentData.ticketCount} × ${paymentData.ticketPrice.toStringAsFixed(2)} RSD\n"
                        "Total: ${paymentData.total.toStringAsFixed(2)} RSD",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    _buildInputField(
                      "Card Number",
                      _cardNumberController,
                      hint: "XXXX XXXX XXXX XXXX",
                      validator: (value) => value != null && value.length == 16
                          ? null
                          : "Enter 16 digits",
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      "Expiry MM/YY",
                      _expiryController,
                      hint: "MM/YY",
                      validator: (value) => value != null && value.contains('/')
                          ? null
                          : "Enter MM/YY",
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      "CVV",
                      _cvvController,
                      hint: "XXX",
                      validator: (value) => value != null && value.length == 3
                          ? null
                          : "Enter 3 digits",
                    ),
                    const SizedBox(height: 30),

                    // Dugme za plaćanje
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildPayButton(paymentData),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller, {
    String? hint,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.grey[850]?.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: validator,
    );
  }

  Widget _buildPayButton(PaymentDto paymentData) {
    return GestureDetector(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          setState(() => isLoading = true);
          try {
            await reservationService.payReservation(
              paymentData.reservationId,
              _cardNumberController.text,
              _expiryController.text,
              _cvvController.text,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Payment successful!")),
            );
            Navigator.pushReplacementNamed(context, '/tickets');
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Payment failed: $e")));
          } finally {
            setState(() => isLoading = false);
          }
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: GlobalColors.red,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: Text(
            "Pay Now",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
