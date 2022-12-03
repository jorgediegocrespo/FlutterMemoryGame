import 'package:flutter/material.dart';

import 'package:flutter_memory_game/features/features.dart';
import 'package:flutter_memory_game/main.dart';
import 'package:flutter_memory_game/services/services.dart';

class NavigationService implements NavigationServiceBase {
  @override
  void navigateBack() {
    navigatorKey.currentState!.pop();
  }

  @override
  void navigateBackToStart() {
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  @override
  Future navigateTo(String route, Object? arguments) {
    return navigatorKey.currentState!.pushNamed(route, arguments: arguments);
  }

  @override
  Future navigateToGameOverPopup(bool gameWon) async {
    await showDialog(
        barrierDismissible: false,
        context: navigatorKey.currentContext!,
        builder: (_) => AlertDialog(contentPadding: const EdgeInsets.all(0), content: GameOverPage(arguments: gameWon)));
  }
}
