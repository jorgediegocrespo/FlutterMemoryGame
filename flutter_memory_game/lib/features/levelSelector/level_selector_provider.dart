import 'package:flutter/material.dart';

class LevelSelectorProvider with ChangeNotifier {
  late AnimationController animationController;
  late Animation<double> labelAnimation;
  late Animation<double> backAnimation;
  late Animation<double> highAnimation;
  late Animation<double> mediumAnimation;
  late Animation<double> lowAnimation;

  bool _isNavigatingHigh = false;
  bool _isNavigatingMedium = false;
  bool _isNavigatingLow = false;
  bool _isNavigatingBack = false;

  LevelSelectorProvider({required TickerProvider vsync}) {
    animationController = AnimationController(vsync: vsync, duration: const Duration(seconds: 1));

    double step = 0.5 / 4.0;
    backAnimation = _getAppearingAnimation(step, 0);
    labelAnimation = _getAppearingAnimation(step, 1);
    lowAnimation = _getAppearingAnimation(step, 2);
    mediumAnimation = _getAppearingAnimation(step, 3);
    highAnimation = _getAppearingAnimation(step, 4); 

    animationController.forward();
  }

  bool get isNavigatingHigh => _isNavigatingHigh;
  set isNavigatingHigh(bool value) {
    _isNavigatingHigh = value;
    notifyListeners();
  }

  bool get isNavigatingMedium => _isNavigatingMedium;
  set isNavigatingMedium(bool value) {
    _isNavigatingMedium = value;
    notifyListeners();
  }

  bool get isNavigatingLow => _isNavigatingLow;
  set isNavigatingLow(bool value) {
    _isNavigatingLow = value;
    notifyListeners();
  }

  bool get isNavigatingBack => _isNavigatingBack;
  set isNavigatingBack(bool value) {
    _isNavigatingBack = value;
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
