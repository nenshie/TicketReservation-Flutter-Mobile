import 'package:flutter/material.dart';
import 'package:cinema_reservations_front/models/user.dart';


class UserProvider with ChangeNotifier {
  User? _user;


  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }


  void logout() {
    _user = null;
    notifyListeners();
  }
}