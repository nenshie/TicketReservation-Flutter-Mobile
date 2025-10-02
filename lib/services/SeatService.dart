import 'dart:convert';
import 'package:cinema_reservations_front/models/dto/SeatDto.dart';
import 'package:http/http.dart' as http;
import 'package:cinema_reservations_front/models/dto/OccupiedSeatDto.dart';
import '../utils/api_handler.dart';

class SeatService {

  Future<List<OccupiedSeat>> fetchSeatsWithAvailability(int projectionId) async {
    final uri = Uri.parse('${BaseAPI.base}/seats/availability')
        .replace(queryParameters: {'projectionId': projectionId.toString()});

    final response = await http.get(uri);

    print('Seats: ${response.body}');

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => OccupiedSeat.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch seats availability");
    }
  }

}