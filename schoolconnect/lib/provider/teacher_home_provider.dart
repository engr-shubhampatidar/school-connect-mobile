import 'package:flutter/material.dart';

class TeacherHomeProvider extends ChangeNotifier {
  int _selectedTodayIndex = 0;

  int get selectedTodayIndex => _selectedTodayIndex;

  void selectTodayIndex(int idx) {
    if (_selectedTodayIndex == idx) return;
    _selectedTodayIndex = idx;
    notifyListeners();
  }
}
