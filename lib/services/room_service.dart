import 'dart:convert';
import 'package:cinema_reservations_front/models/dto/RoomDto.dart';
import 'package:http/http.dart' as http;

class RoomService {
  static const String ipPort = "172.20.10.5:5215";
  static const String baseUrl = "http://$ipPort/api/room";

  static Future<List<Room>> fetchAllRooms() async {
    final uri = Uri.parse(baseUrl);
    final response = await http.get(uri);
    // print('--- ROOM FETCH LOG ---');
    // print("URL: $uri");
    // print("Status code: ${response.statusCode}");
    // print("Response body: ${response.body}");
    // print('------------------------');
    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Room.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load rooms");
    }
  }
}