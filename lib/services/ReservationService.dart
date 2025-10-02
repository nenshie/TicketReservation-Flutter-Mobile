import 'dart:convert';
import 'package:cinema_reservations_front/models/dto/ProjectoinDto.dart';
import 'package:cinema_reservations_front/models/dto/ReservationDto.dart';
import 'package:cinema_reservations_front/models/dto/SeatDto.dart';
import 'package:http/http.dart' as http;

import '../utils/api_handler.dart';

class ReservationService {

  Future<int> makeReservation(String? userId, int projectionId, List<Seat> seats) async {
    final url = Uri.parse('${BaseAPI.base}/reservations/make');

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
      final data = json.decode(response.body);
      return data['reservationId']; // vraća ID rezervacije
    } else {
      throw Exception('Failed to send reservation: ${response.statusCode} ${response.body}');
    }
  }

  Future<List<Projection>> fetchAllReservations() async {
    final uri = Uri.parse('${BaseAPI.base}/reservations/get-all');

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
    final uri = Uri.parse('${BaseAPI.base}/reservations/user/$userId');
    final response = await http.get(uri);

    print('--- RESERVATION FETCH LOG ---');
    print("URL: $uri");
    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");
    print('------------------------');

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      List<Reservation> allReservations = [];

      for (var resJson in data) {
        final status = resJson['status'];
        final tickets = resJson['tickets'] as List? ?? [];

        for (var t in tickets) {
          final filmTitle = t['filmTitle'] ?? '';
          final projectionDate = t['projectionDate'] ?? '';
          final projectionTime = t['projectionTime'] ?? '';
          final seatRow = t['seatRow'];
          final seatNumber = t['seatNumber'];

          allReservations.add(
            Reservation(
              reservationId: resJson['reservationId'] ?? 0,
              filmTitle: filmTitle,
              date: projectionDate.toString().isNotEmpty
                  ? projectionDate.toString().substring(0, 10)
                  : '',
              time: projectionTime.toString().isNotEmpty
                  ? projectionTime.toString().substring(11, 16)
                  : '',
              status: status,
              seats: seatRow != null && seatNumber != null
                  ? ['Row $seatRow, Seat $seatNumber']
                  : [],
              qrCodeBase64: t['qrCode'],
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
    final url = Uri.parse('${BaseAPI.base}/reservations/confirm-from-qr');

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


  Future<void> payReservation(int reservationId, String cardNumber, String expiryDate, String cvv) async {
    final response = await http.post(
      Uri.parse('${BaseAPI.base}/reservations/$reservationId/pay'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "cardNumber": cardNumber,
        "expiryDate": expiryDate,
        "cvv": cvv,
      }),
    );

    print('--- RESERVATION PAYMENT LOG ---');
    print("Status code: ${response.statusCode}");
    print("Response body: ${response.body}");
    print('------------------------');

    if (response.statusCode != 200) {
      throw Exception(response.body.isNotEmpty ? response.body : "Unknown error");
    }
  }


}
