import 'package:flutter/material.dart';

class Name with ChangeNotifier {
  String _name = "Oeschinen Lake Campground";

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }
}
