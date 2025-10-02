import 'dart:ffi';

import 'package:cinema_reservations_front/models/dto/FilmDto.dart';
import 'package:cinema_reservations_front/models/dto/RoomDto.dart';
import 'package:cinema_reservations_front/models/dto/GenreDto.dart';

class Projection {
  final int projectionId;
  final Film film;
  final Room room;
  final DateTime dateTime;
  final bool active;
  final DateTime? salesOpenUntil;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double price;

  Projection({
    required this.projectionId,
    required this.film,
    required this.room,
    required this.dateTime,
    required this.active,
    required this.price,
    this.salesOpenUntil,
    this.createdAt,
    this.updatedAt,
  });

  factory Projection.fromJson(Map<String, dynamic> json) {
    return Projection(
      projectionId: json['projectionId'],
      film: Film.fromJson(json),
      room: Room(
        roomId: json['roomId'],
        name: json['roomName'] ?? 'Unknown Room',
        numberOfRows: json['numberOfRows'],
        seatsPerRow: json['seatsPerRow'],
      ),
      dateTime: DateTime.parse(json['dateTime']),
      active: json['active'] ?? true,
      price: json['price'] ,
      salesOpenUntil: json['salesOpenUntil'] != null ? DateTime.parse(json['salesOpenUntil']) : null,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }
}
