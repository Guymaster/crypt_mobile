import 'package:flutter/material.dart';

class UserPreferencesProvider extends ChangeNotifier {
  int _timeToLock = 5;
  String? _importDirectory;
  String? _exportDirectory;

  int get timeToLock {
    return _timeToLock;
  }
  String? get importDirectory {
    return _importDirectory;
  }
  String? get exportDirectory {
    return _exportDirectory;
  }

  set timeToLock(int t) {
    _timeToLock = t;
    notifyListeners();
  }
  set importDirectory(String? d) {
    _importDirectory = d;
    notifyListeners();
  }
  set exportDirectory(String? d) {
    _exportDirectory = d;
    notifyListeners();
  }

  fetch(){
    timeToLock = 5;
  }
}