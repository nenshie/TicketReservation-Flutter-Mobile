class PaymentDto {
  final int reservationId;
  final String movieTitle;
  final DateTime dateTime;
  final int ticketCount;
  final double ticketPrice;

  PaymentDto({
    required this.reservationId,
    required this.movieTitle,
    required this.dateTime,
    required this.ticketCount,
    required this.ticketPrice,
  });

  double get total => ticketCount * ticketPrice;
}
