import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:flutter_memory_game/models/game_info.dart';
import 'package:flutter_memory_game/models/themes.dart';
import 'package:flutter_memory_game/router/routes.dart';
import 'package:flutter_memory_game/services/services.dart';

class ThemeSelectorProvider with ChangeNotifier {
  late AnimationController animationController;
  late Animation<double> labelAnimation;
  late Animation<double> dcAnimation;
  late Animation<double> marvelAnimation;
  late Animation<double> simpsonsAnimation;
  late Animation<double> starWarsAnimation;
  late NavigationServiceBase _navigationService;
  late GameInfo _gameInfo;

  bool _isNavigatingDc = false;
  bool _isNavigatingMarvel = false;
  bool _isNavigatingSimpsons = false;
  bool _isNavigatingStarWars = false;

  ThemeSelectorProvider({required TickerProvider vsync}) {
    _gameInfo = GameInfo();
    _navigationService = GetIt.I<NavigationServiceBase>();
    animationController = AnimationController(vsync: vsync, duration: const Duration(seconds: 1));

    double step = 0.5 / 4.0;
    labelAnimation = _getAppearingAnimation(step, 0);
    dcAnimation = _getAppearingAnimation(step, 1);
    marvelAnimation = _getAppearingAnimation(step, 2);
    simpsonsAnimation = _getAppearingAnimation(step, 3);
    starWarsAnimation = _getAppearingAnimation(step, 4);

    animationController.forward();
  }

  bool get isNavigatingDc => _isNavigatingDc;
  set isNavigatingDc(bool value) {
    _isNavigatingDc = value;
    notifyListeners();
  }

  bool get isNavigatingMarvel => _isNavigatingMarvel;
  set isNavigatingMarvel(bool value) {
    _isNavigatingMarvel = value;
    notifyListeners();
  }

  bool get isNavigatingSimpsons => _isNavigatingSimpsons;
  set isNavigatingSimpsons(bool value) {
    _isNavigatingSimpsons = value;
    notifyListeners();
  }

  bool get isNavigatingStarWars => _isNavigatingStarWars;
  set isNavigatingStarWars(bool value) {
    _isNavigatingStarWars = value;
    notifyListeners();
  }

  void selectDc() {
    isNavigatingDc = true;
    animationController.reverse().whenCompleteOrCancel(() {
      _gameInfo.theme = Themes.dc;
      _navigationService.navigateTo(Routes.levelSelector, _gameInfo).then((value) => animationController.forward());
      isNavigatingDc = false;
    });
  }

  void selectMarvel() {
    isNavigatingMarvel = true;
    animationController.reverse().whenCompleteOrCancel(() {
      _gameInfo.theme = Themes.marvel;
      _navigationService.navigateTo(Routes.levelSelector, _gameInfo).then((value) => animationController.forward());
      isNavigatingMarvel = false;
    });
  }

  void selectSimpsons() {
    isNavigatingSimpsons = true;
    animationController.reverse().whenCompleteOrCancel(() {
      _gameInfo.theme = Themes.simpsons;
      _navigationService.navigateTo(Routes.levelSelector, _gameInfo).then((value) => animationController.forward());
      isNavigatingSimpsons = false;
    });
  }

  void selectStarWars() {
    isNavigatingStarWars = true;
    animationController.reverse().whenCompleteOrCancel(() {
      _gameInfo.theme = Themes.starWars;
      _navigationService.navigateTo(Routes.levelSelector, _gameInfo).then((value) => animationController.forward());
      isNavigatingStarWars = false;
    });
  }

  Animation<double> _getAppearingAnimation(double step, int index) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Interval(step * index, 0.5 + step * index, curve: Curves.linear)));
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}
