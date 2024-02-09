import 'package:flutter/material.dart';

class LikeCount extends ChangeNotifier {
  int _likeCount = 0;

  int get likeCount => _likeCount;

  void incrementLikeCount() {
    _likeCount++;
    notifyListeners();
  }
}