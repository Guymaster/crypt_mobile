import 'package:flutter/material.dart';

class SecretKeyProvider extends ChangeNotifier {
  String? _value;

  String get value {
    return (_value != null)? _value! : "";
  }

  set value(String v) {
    _value = v;
    notifyListeners();
  }
}