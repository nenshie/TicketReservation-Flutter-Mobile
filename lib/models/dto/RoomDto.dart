class Room {
  final int roomId;
  final String name;
  final int numberOfRows;
  final int seatsPerRow;

  Room({
    required this.roomId,
    required this.name,
    required this.numberOfRows,
    required this.seatsPerRow
  });


  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['roomId'],
      name: json['name'] ?? 'Unknown Room name',
      numberOfRows  : json['numberOfRows'] ?? 0,
      seatsPerRow  : json['seatsPerRow'] ?? 0,
    );
  }
}