import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:flutter_memory_game/services/services.dart';

class GameOverProvider with ChangeNotifier {
  late NavigationServiceBase _navigationService;
  late bool _gameWon;

  bool _isClosing = false;
  bool _isNavigatingToPlayAgain = false;

  GameOverProvider({required bool gameWon}) {
    _navigationService = GetIt.I<NavigationServiceBase>();
    _gameWon = gameWon;
  }

  bool get isClosing => _isClosing;
  set isClosing(bool value) {
    _isClosing = value;
    notifyListeners();
  }

  bool get isNavigatingToPlayAgain => _isNavigatingToPlayAgain;
  set isNavigatingToPlayAgain(bool value) {
    _isNavigatingToPlayAgain = value;
    notifyListeners();
  }

  bool get gameWon => _gameWon;

  void playAgain() {
    isNavigatingToPlayAgain = true;
    _navigationService.navigateBack();
    isNavigatingToPlayAgain = false;
  }

  void close() {
    isClosing = true;
    _navigationService.navigateBackToStart();
    isClosing = false;
  }
}
