class OccupiedSeat {
  final int seatId;
  final int row;
  final int column;
  final bool isTaken;

  OccupiedSeat({
    required this.seatId,
    required this.row,
    required this.column,
    required this.isTaken,
  });

  factory OccupiedSeat.fromJson(Map<String, dynamic> json) {
    return OccupiedSeat(
      seatId: json['seatId'],
      row: json['rowNumber'],
      column: json['seatNumber'],
      isTaken: json['occupied'],
    );
  }
}
