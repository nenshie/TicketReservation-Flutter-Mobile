import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cinema_reservations_front/models/dto/FilmDto.dart';
import '../utils/api_handler.dart';

class FilmService {

  static Future<List<Film>> fetchAllFilms({
    int page = 0,
    int size = 10,
    String sortBy = "createdAt",
    bool ascending = true,
    String? filterBy,
    String? filterValue,
  }) async {
    final queryParameters = {
      'page': page.toString(),
      'size': size.toString(),
      'sortBy': sortBy,
      'ascending': ascending.toString(),
      if (filterBy != null) 'filterBy': filterBy,
      if (filterValue != null) 'filterValue': filterValue,
    };

    final uri = Uri.parse('${BaseAPI.base}/films').replace(queryParameters: queryParameters);

    print("---- FILM FETCH REQUEST ----");
    print("URL: $uri");

    final response = await http.get(uri, headers: BaseAPI.defaultHeaders);


    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      List content = decoded['content'];
      print("Response content: $content");

      return content.map((filmJson) => Film.fromJson(filmJson)).toList();
    } else {
      print("Error response body: ${response.body}");
      throw Exception("Failed to load films");
    }
  }
}
