import 'package:flutter/material.dart';

class ThemeSelectorProvider with ChangeNotifier {
  late AnimationController animationController;
  late Animation<double> labelAnimation;
  late Animation<double> dcAnimation;
  late Animation<double> marvelAnimation;
  late Animation<double> simpsonsAnimation;
  late Animation<double> starWarsAnimation;

  bool _isNavigatingDc = false;
  bool _isNavigatingMarvel = false;
  bool _isNavigatingSimpsons = false;
  bool _isNavigatingStarWars = false;

  ThemeSelectorProvider({required TickerProvider vsync}) {
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

  Animation<double> _getAppearingAnimation(double step, int index) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve:
            Interval(step * index, 0.5 + step * index, curve: Curves.linear)));
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}
