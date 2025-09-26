import 'dart:convert';
import 'package:cinema_reservations_front/models/dto/ProjectoinDto.dart';
import 'package:cinema_reservations_front/models/dto/ReservationDto.dart';
import 'package:cinema_reservations_front/models/dto/SeatDto.dart';
import 'package:http/http.dart' as http;

class ReservationService {
  static const String ipPort = "172.20.10.5:5215";
  static const String baseUrl = "http://$ipPort/api/reservation";


  Future<bool> makeReservation(String? userId, int projectionId, List<Seat> seats) async {
    final url = Uri.parse("$baseUrl/make");

    final seatsJson = seats.map((seat) => seat.toJson()).toList();

    final body = jsonEncode({
      'projectionId': projectionId,
      'userId': userId,
      'seats': seatsJson,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    print('--- RESERVATION POST LOG ---');
    print("URL: $url");
    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");
    print('----------------------------');

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to send reservation: ${response.statusCode} ${response.body}');
    }
  }

  Future<List<Projection>> fetchAllReservations() async {
    final uri = Uri.parse(baseUrl);

    final response = await http.get(uri);

    // print('--- RESERVATION FETCH LOG ---');
    // print("URL: $uri");
    // print("Status code: ${response.statusCode}");
    // print("Response body: ${response.body}");
    // print('----------------------------');

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((projectionJson) => Projection.fromJson(projectionJson)).toList();
    } else {
      throw Exception("Failed to load reservations");
    }
  }

  Future<List<Reservation>> getMyReservations(String userId) async {
    final uri = Uri.parse("$baseUrl/user/$userId");
    final response = await http.get(uri);

    // print('--- RESERVATION FETCH LOG ---');
    // print("URL: $uri");
    // print("Status code: ${response.statusCode}");
    // print("Response body: ${response.body}");
    // print('------------------------');
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      List<Reservation> allReservations = [];
      for (var resJson in data) {
        final ticket = resJson['ticket'];
        final status = resJson['status'];
        final projection = ticket?['projection'];
        final film = projection?['film'];
        final seats = ticket?['seats'] ?? [ticket?['seat']];

        if (seats is List) {
          for (var seat in seats) {
            allReservations.add(
              Reservation(
                reservationId: ticket?['ticketId'] ?? 0,
                filmTitle: film?['title'] ?? '',
                date: (projection?['date'] ?? '').toString().substring(0, 10),
                time: (projection?['time'] ?? '').toString().substring(11, 16),
                status: status,
                seats: ['Row ${seat["rowNumber"]}, Seat ${seat["seatNumber"]}'],
                qrCodeBase64: ticket?['qrCode'],
              ),
            );
          }
        } else if (seats != null) {
          allReservations.add(
            Reservation(
              reservationId: ticket?['ticketId'] ?? 0,
              filmTitle: film?['title'] ?? '',
              date: (projection?['date'] ?? '').toString().substring(0, 10),
              time: (projection?['time'] ?? '').toString().substring(11, 16),
              status: status,
              seats: ['Row ${seats["rowNumber"]}, Seat ${seats["seatNumber"]}'],
              qrCodeBase64: ticket?['qrCode'],
            ),
          );
        }
      }
      return allReservations;
    } else {
      throw Exception("Failed to load user reservations");
    }
  }

  Future<bool> confirmReservationFromQr(String qrContent) async {
    final url = Uri.parse("$baseUrl/confirm-from-qr");

    final body = jsonEncode({
      'qrContent': qrContent
    });

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: body
    );
    print('Sending QR to backend: $qrContent');

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Greška: ${response.body}');
      return false;
    }
  }

}
