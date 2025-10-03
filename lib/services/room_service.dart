import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinema_reservations_front/models/dto/RoomDto.dart';
import '../utils/api_handler.dart';

class RoomService {
  static Future<List<Room>> fetchAllRooms() async {
    final uri = Uri.parse('${BaseAPI.base}/rooms');

    print("---- ROOM FETCH REQUEST ----");
    print("URL: $uri");

    final response = await http.get(uri, headers: BaseAPI.defaultHeaders);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is List) {
        print("Response list: $decoded");
        return decoded.map((roomJson) => Room.fromJson(roomJson)).toList();
      }

      throw Exception("Unexpected response format: $decoded");
    } else {
      print("Error response body: ${response.body}");
      throw Exception("Failed to load rooms");
    }
  }
}
