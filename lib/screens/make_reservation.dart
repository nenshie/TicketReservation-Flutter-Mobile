import 'package:cinema_reservations_front/components/bottom_nav_bar.dart';
import 'package:cinema_reservations_front/models/dto/OccupiedSeatDto.dart';
import 'package:cinema_reservations_front/models/dto/ProjectoinDto.dart';
import 'package:cinema_reservations_front/services/SeatService.dart';
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
  List<String> selectedSeats = [];

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
    return takenSeats.any(
            (seat) => seat.row == rowNumber && seat.column == seatNumber && seat.isTaken
    );
  }

  String formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0 && remainingMinutes > 0) {
      return '${hours}h ${remainingMinutes}m';
    } else if (hours > 0) {
      return '${hours}h';
    } else {
      return '${remainingMinutes}m';
    }
  }

  // String formatProjectionDateTime(String rawDate, String rawTime) {
  //   try {
  //     final date = DateTime.parse(rawDate);
  //     final time = DateTime.parse(rawTime);
  //
  //     final formattedDate =
  //         '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  //     final formattedTime =
  //         '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  //
  //     return 'Date:  $formattedDate\nTime: $formattedTime';
  //   } catch (e) {
  //     return '$rawDate $rawTime';
  //   }
  // }

  String formatProjectionDateTime(DateTime dateTime) {
    final formattedDate =
        '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.year}';
    final formattedTime =
        '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';

    return 'Date: $formattedDate\nTime: $formattedTime';
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
    print('Number of rows: ${projection.room.numberOfRows}');
    print('Seats per row: ${projection.room.seatsPerRow}');

    final totalSeats = projection.room.numberOfRows * projection.room.seatsPerRow;

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
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 120,
                      height: 200,
                      color: Colors.grey[800],
                      child: const Icon(Icons.broken_image, color: Colors.white),
                    ),
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
                        formatDuration(projection.film.duration),
                        style:
                        const TextStyle(color: Colors.white70, fontSize: 18),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatProjectionDateTime(projection.dateTime),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          height: 1.5,
                        ),
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
          Expanded(
            child: SingleChildScrollView(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  projection.room.numberOfRows,
                      (rowIndex) {
                    final rowNumber = rowIndex + 1;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: LayoutBuilder(builder: (context, constraints) {
                        const seatIconSize = 33.0;
                        const seatPadding = 10.0;
                        int seatsPerLine =
                        (constraints.maxWidth / (seatIconSize + seatPadding))
                            .floor();

                        final maxSeatsInRow = projection.room.seatsPerRow;
                        seatsPerLine = seatsPerLine > maxSeatsInRow
                            ? maxSeatsInRow
                            : seatsPerLine;

                        List<Widget> seatLines = [];
                        for (int startSeat = 0;
                        startSeat < maxSeatsInRow;
                        startSeat += seatsPerLine) {
                          final endSeat = (startSeat + seatsPerLine > maxSeatsInRow)
                              ? maxSeatsInRow
                              : startSeat + seatsPerLine;
                          final seatsInThisLine = endSeat - startSeat;

                          seatLines.add(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(seatsInThisLine, (index) {
                                final seatNumberInRow = startSeat + index + 1;
                                final seatId = '$rowNumber-$seatNumberInRow';

                                final isTaken =
                                isSeatTaken(rowNumber, seatNumberInRow);
                                final isSelected = selectedSeats.contains(seatId);

                                return GestureDetector(
                                  onTap: () {
                                    if (!isTaken) {
                                      setState(() {
                                        if (isSelected) {
                                          selectedSeats.remove(seatId);
                                        } else {
                                          selectedSeats.add(seatId);
                                        }
                                      });
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Icon(
                                      Icons.chair,
                                      color: isTaken
                                          ? Colors.grey
                                          : isSelected
                                          ? GlobalColors.red
                                          : Colors.white,
                                      size: seatIconSize,
                                    ),
                                  ),
                                );
                              }),
                            ),
                          );
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: seatLines,
                        );
                      }),
                    );
                  },
                ),
              ),
            ),
          ),

          if (selectedSeats.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final user =
                        Provider.of<UserProvider>(context, listen: false).user;
                    final String? userId = user?.jmbg;

                    List<Seat> seatsToReserve = selectedSeats.map((seatId) {
                      final parts = seatId.split('-');
                      final rowNumber = int.parse(parts[0]);
                      final seatInRow = int.parse(parts[1]);

                      return Seat(
                        roomId: projection.room.roomId,
                        projectionId: projection.projectionId,
                        rowNumber: rowNumber,
                        seatNumber: seatInRow,
                        isTaken: false,
                      );
                    }).toList();

                    await reservationService.makeReservation(
                        userId, projection.projectionId, seatsToReserve);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                          Text("You have successfully booked your tickets!")),
                    );
                    Navigator.pushReplacementNamed(context, '/tickets');
                    setState(() {
                      selectedSeats.clear();
                    });
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Booking error: $e")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: GlobalColors.red,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 60, vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text(
                  "Reserve",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
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
