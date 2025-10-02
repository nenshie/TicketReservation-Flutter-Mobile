import 'package:cinema_reservations_front/components/bottom_nav_bar.dart';
import 'package:cinema_reservations_front/models/dto/OccupiedSeatDto.dart';
import 'package:cinema_reservations_front/models/dto/PaymentDto.dart';
import 'package:cinema_reservations_front/models/dto/ProjectoinDto.dart';
import 'package:cinema_reservations_front/screens/payment_option.dart';
import 'package:cinema_reservations_front/services/SeatService.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/dto/SeatDto.dart';
import '../providers/user_provider.dart';
import '../services/ReservationService.dart';
import '../utils/global_colors.dart';

class MakeReservation extends StatefulWidget {
  const MakeReservation({super.key});

  @override
  State<MakeReservation> createState() => _MakeReservationState();
}

class _MakeReservationState extends State<MakeReservation> {
  final int _currentIndex = 1;
  final SeatService seatService = SeatService();
  final ReservationService reservationService = ReservationService();

  List<OccupiedSeat> takenSeats = [];
  bool isLoading = true;
  List<OccupiedSeat> selectedSeats = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projection = ModalRoute.of(context)!.settings.arguments as Projection;
      _loadTakenSeats(projection.projectionId);
    });
  }

  Future<void> _loadTakenSeats(int projectionId) async {
    try {
      final seats = await seatService.fetchSeatsWithAvailability(projectionId);
      setState(() {
        takenSeats = seats;
        isLoading = false;
      });
    } catch (e) {
      print('Greška prilikom učitavanja sedišta: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  bool isSeatTaken(int rowNumber, int seatNumber) {
    return takenSeats.any((s) => s.row == rowNumber && s.column == seatNumber && s.isTaken);
  }

  bool isSeatSelected(int rowNumber, int seatNumber) {
    return selectedSeats.any((s) => s.row == rowNumber && s.column == seatNumber);
  }

  void toggleSeatSelection(int rowNumber, int seatNumber) {
    final seat = takenSeats.firstWhere(
          (s) => s.row == rowNumber && s.column == seatNumber,
      orElse: () => OccupiedSeat(seatId: -1, row: rowNumber, column: seatNumber, isTaken: false),
    );

    if (seat.isTaken) return;

    setState(() {
      if (isSeatSelected(rowNumber, seatNumber)) {
        selectedSeats.removeWhere((s) => s.row == rowNumber && s.column == seatNumber);
      } else {
        selectedSeats.add(seat);
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final projection = ModalRoute.of(context)!.settings.arguments as Projection;

    final seatsByRow = groupBy(takenSeats, (OccupiedSeat seat) => seat.row);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Reservation', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // Film info sa cenom
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    projection.film.posterUrl,
                    width: 140,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        projection.film.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${projection.film.duration ~/ 60}h ${projection.film.duration % 60}m',
                        style: const TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date: ${projection.dateTime.day.toString().padLeft(2,'0')}.${projection.dateTime.month.toString().padLeft(2,'0')}.${projection.dateTime.year}\n'
                            'Time: ${projection.dateTime.hour.toString().padLeft(2,'0')}:${projection.dateTime.minute.toString().padLeft(2,'0')}',
                        style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '💰 ${projection.price.toStringAsFixed(2)} RSD',
                        style: const TextStyle(color: Colors.orangeAccent, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Choose seats",
                style: TextStyle(color: Colors.white, fontSize: 18)),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white30),
              ),
              alignment: Alignment.center,
              child: const Text(
                "SCREEN",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          // Seats
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: List.generate(projection.room.numberOfRows, (rowIndex) {
                  final rowNumber = rowIndex + 1;
                  final seatsInRow = seatsByRow[rowNumber] ??
                      List.generate(projection.room.seatsPerRow,
                              (index) => OccupiedSeat(seatId: -1, row: rowNumber, column: index + 1, isTaken: false));

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: seatsInRow.map((seat) {
                        final taken = seat.isTaken;
                        final selected = isSeatSelected(seat.row, seat.column);

                        return GestureDetector(
                          onTap: () => toggleSeatSelection(seat.row, seat.column),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Icon(
                              Icons.chair,
                              color: taken
                                  ? Colors.grey
                                  : selected
                                  ? GlobalColors.red
                                  : Colors.white,
                              size: 33,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
              ),
            ),
          ),
          // Reserve button
          if (selectedSeats.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final user = Provider.of<UserProvider>(context, listen: false).user;
                    final userId = user?.jmbg;
                    if (userId == null) throw Exception("User not logged in");

                    final seatsToReserve = selectedSeats.map((s) => Seat(
                      seatId: s.seatId,
                      roomId: projection.room.roomId,
                      projectionId: projection.projectionId,
                      rowNumber: s.row,
                      seatNumber: s.column,
                      isTaken: false,
                    )).toList();

                    final reservationId = await reservationService.makeReservation(
                      userId,
                      projection.projectionId,
                      seatsToReserve,
                    );

                    final paymentData = PaymentDto(
                      reservationId: reservationId,
                      movieTitle: projection.film.title,
                      dateTime: projection.dateTime,
                      ticketCount: selectedSeats.length,
                      ticketPrice: projection.price,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentOptionPage(paymentData: paymentData),
                      ),
                    );

                    setState(() => selectedSeats.clear());
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Booking error: $e")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: GlobalColors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text("Reserve", style: TextStyle(fontSize: 20, color: Colors.white)),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
