class Reservation {
  final int reservationId;
  final String filmTitle;
  final String date;
  final String time;
  final String status;
  final List<String> seats;
  final String? qrCodeBase64;

  Reservation({
    required this.reservationId,
    required this.filmTitle,
    required this.date,
    required this.time,
    required this.status,
    required this.seats,
    this.qrCodeBase64,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      reservationId: json["reservationId"],
      filmTitle: json["filmTitle"],
      date: json["date"],
      time: json["time"],
      status: json["status"],
      seats: List<String>.from(json["seats"] ?? []),
      qrCodeBase64: json["ticket"]?["qrCode"],
    );
  }
}
