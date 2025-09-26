class BaseAPI {
  static const String ipPort = "10.0.2.2:8082";
  static const String base = "http://$ipPort/ticket-reservation";

  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
}
