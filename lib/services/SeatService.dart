import 'dart:convert';
import 'package:cinema_reservations_front/models/dto/SeatDto.dart';
import 'package:http/http.dart' as http;
import 'package:cinema_reservations_front/models/dto/OccupiedSeatDto.dart';

class SeatService {
  static const String ipPort = "172.20.10.5:5215";
  static const String baseUrl = "http://$ipPort/api/seat";

  Future<List<OccupiedSeat>> fetchSeatsWithAvailability(int projectionId) async {
    final uri = Uri.parse('$baseUrl/availability')
        .replace(queryParameters: {'projectionId': projectionId.toString()});

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => OccupiedSeat.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch seats availability");
    }
  }

}