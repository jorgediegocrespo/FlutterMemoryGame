import 'package:flutter/material.dart';

import 'package:flutter_memory_game/features/features.dart';

class Routes {
  static const themeSelector = 'themeSelector';
  static const levelSelector = 'levelSelector';
  static const game = 'game';
  static const gameOver = 'gameOver';

  static const initialRoute = themeSelector;

  static final Map<String, Widget Function(BuildContext, Object?)> appRoutes = {
    themeSelector: (BuildContext context, Object? arguments) => ThemeSelectorPage(arguments: arguments),
    levelSelector: (BuildContext context, Object? arguments) => LevelSelectorPage(arguments: arguments),
    game: (BuildContext context, Object? arguments) => GamePage(arguments: arguments),
    gameOver: (BuildContext context, Object? arguments) => const GameOverPage()
  };

  static Map<String, Widget Function(BuildContext, Object arguments)> getAppRoutes() => appRoutes;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return PageRouteBuilder(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, __, ___) => appRoutes[settings.name]!(context, settings.arguments));
  }
}
