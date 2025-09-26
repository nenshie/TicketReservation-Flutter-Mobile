class Seat {
  final int roomId;
  final int projectionId;
  final int rowNumber;
  final int seatNumber;
  final bool isTaken;

  Seat({
    required this.roomId,
    required this.projectionId,
    required this.rowNumber,
    required this.seatNumber,
    required this.isTaken,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      roomId: json['roomId'],
      projectionId: json['projectionId'],
      rowNumber: json['rowNumber'],
      seatNumber: json['seatNumber'],
      isTaken: json['isTaken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roomId': roomId,
      'projectionId': projectionId,
      'rowNumber': rowNumber,
      'seatNumber': seatNumber,
      'isTaken': isTaken,
    };
  }
}
