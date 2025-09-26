import 'dart:convert';
import 'package:cinema_reservations_front/models/dto/ProjectoinDto.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/api_handler.dart';

class ProjectionService {

  Future<List<Projection>> fetchAllProjections({int page = 0, int size = 10}) async {
    final uri = Uri.parse('${BaseAPI.base}/projections').replace(queryParameters: {
      'page': page.toString(),
      'size': size.toString(),
    });

    print("---- PROJECTION FETCH REQUEST ----");
    print("URL: $uri");

    final response = await http.get(uri, headers: BaseAPI.defaultHeaders);

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List content = decoded['content'];
      print("Response content: $content");
      return content.map((json) => Projection.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load projections: ${response.statusCode}");
    }
  }

  static Future<bool> addProjection({
    required int filmId,
    required int roomId,
    required DateTime date,
    required TimeOfDay time,
  }) async {

    final uri = Uri.parse('${BaseAPI.base}/films');

    final projectionDate = DateTime(date.year, date.month, date.day);

    final projectionTime = DateTime(1, 1, 1, time.hour, time.minute);

    final payload = {
      "filmId": filmId,
      "roomId": roomId,
      "date": projectionDate.toIso8601String(),
      "time": projectionTime.toIso8601String(),
    };

    final response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(payload),
    );

    print("POST Projection => ${response.statusCode}");
    print(response.body);

    return response.statusCode == 201;
  }
}