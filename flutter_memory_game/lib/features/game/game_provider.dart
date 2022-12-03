import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_memory_game/controls/controls.dart';
import 'package:flutter_memory_game/main.dart';
import 'package:flutter_memory_game/models/models.dart';
import 'package:flutter_memory_game/services/services.dart';

class GameProvider with ChangeNotifier {
  late AnimationController animationController;
  late Animation<double> backAnimation;
  late Animation<double> pairsAnimation;
  late Animation<double> attempsAnimation;
  late Animation<double> timerAnimation;
  late Animation<double> boardAnimation;
  late NavigationServiceBase _navigationService;
  late DialogServiceBase _dialogService;

  bool _isNavigatingBack = false;
  int _attempsNumber = 0;
  int _cardPairsFound = 0;
  late GameInfo _gameInfo;
  late List<List<CardInfo?>> _board;
  List<List<GameCardController>>? _boardControllers;
  late Duration _remainingTime;
  late Timer _countdown;
  late AppLocalizations _texts;
  CardInfo? _currentCard;
  GameCardController? _currentCardController;
  bool _isShowingCard = false;

  GameProvider({required TickerProvider vsync, required GameInfo gameInfo}) {
    _navigationService = GetIt.I<NavigationServiceBase>();
    _dialogService = GetIt.I<DialogServiceBase>();
    
    _texts = AppLocalizations.of(navigatorKey.currentContext!)!;
    _gameInfo = gameInfo;
    
    animationController = AnimationController(vsync: vsync, duration: const Duration(seconds: 1));

    _createBoard();
    _initCountdown();

    double step = 0.5 / 4.0;
    backAnimation = _getAppearingAnimation(step, 0);
    pairsAnimation = _getAppearingAnimation(step, 1);
    attempsAnimation = _getAppearingAnimation(step, 2);
    timerAnimation = _getAppearingAnimation(step, 3);
    boardAnimation = _getAppearingAnimation(step, 4);

    animationController.forward();
  }

  bool get isNavigatingBack => _isNavigatingBack;
  set isNavigatingBack(bool value) {
    _isNavigatingBack = value;
    notifyListeners();
  }

  int get attempsNumber => _attempsNumber;
  set attempsNumber(int value) {
    _attempsNumber = value;
    notifyListeners();
  }

  int get cardPairsFound => _cardPairsFound;
  set cardPairsFound(int value) {
    _cardPairsFound = value;
    notifyListeners();
  }

  Duration get remainingTime => _remainingTime;
  set remainingTime(Duration value) {
    _remainingTime = value;
    notifyListeners();
  }

  List<List<CardInfo?>> get board => _board;
  List<List<GameCardController>>? get boardControllers => _boardControllers;

  Duration get totalTime {
    switch (_gameInfo.level) {
      case Levels.high:
        return const Duration(minutes: 2);
      case Levels.medium:
        return const Duration(minutes: 4);
      case Levels.low:
      default:
        return const Duration(minutes: 5);
    }
  }

  int get rowCount {
    switch (_gameInfo.level) {
      case Levels.high:
        return 6;
      case Levels.medium:
        return 6;
      case Levels.low:
      default:
        return 4;
    }
  }

  int get columnCount {
    switch (_gameInfo.level) {
      case Levels.high:
        return 5;
      case Levels.medium:
        return 4;
      case Levels.low:
      default:
        return 4;
    }
  }

  Future<void> showCard(int rowIndex, int columIndex, GameCardController controller) async {
    try {
      if (_isShowingCard) {
        return;
      }

      _isShowingCard = true;

      final selectedCell = _board[rowIndex][columIndex];
      if (_currentCard == null) {
        _currentCard = selectedCell;
        _currentCardController = controller;
        await controller.flipCard();
        return;
      }

      if (_currentCard == selectedCell) {
        return;
      }

      await controller.flipCard();
      attempsNumber++;
      if (_currentCard!.imagePath == selectedCell!.imagePath) {
        cardPairsFound++;
        _currentCard!.found = true;
        selectedCell.found = true;
      } else {
        await Future.delayed(const Duration(milliseconds: 1000));
        await Future.wait([controller.flipCard(), _currentCardController!.flipCard()]);
      }

      _currentCard = null;
      _currentCardController = null;

      if (cardPairsFound == rowCount * columnCount / 2) {
        await _finishGame(true);
      }
    } finally {
      _isShowingCard = false;
    }
  }

  Future<void> goBack() async {
    isNavigatingBack = true;
    bool goBack = await _dialogService.showAlertDialog(_texts.gameBackQuestionTitle, _texts.gameBackQuestionMessage, _texts.ok, _texts.cancel);
    if (!goBack) {
      return;
    }
    animationController.reverse().whenCompleteOrCancel(() {
      _navigationService.navigateBack();
      isNavigatingBack = false;
    });
  }

  void _createBoard() {
    _boardControllers ??= List.generate(rowCount, (rowIndex) => List.generate(columnCount, (columnIndex) => GameCardController()));
    _board = List.generate(rowCount, (rowIndex) => List.generate(columnCount, (columnIndex) => null));
    final imagePrefix = _getImagePrefix();

    final int numberOfDistinctCards = rowCount * columnCount ~/ 2;
    int numberOfFilledCards = 0;
    List<int> usedImages = List.empty(growable: true);

    while (numberOfFilledCards < numberOfDistinctCards) {
      int imageIndex = _getImageIndex(usedImages);
      usedImages.add(imageIndex);

      Random random = Random();
      _fillBoardCell(0, "$imagePrefix$imageIndex.jpg");
      _fillBoardCell(random.nextInt(rowCount * columnCount), "$imagePrefix$imageIndex.jpg");

      numberOfFilledCards++;
    }

    notifyListeners();
  }

  String _getImagePrefix() {
    switch (_gameInfo.theme) {
      case Themes.dc:
        return "dc_";
      case Themes.marvel:
        return "marvel_";
      case Themes.simpsons:
        return "simpsons_";
      case Themes.starWars:
      default:
        return "star_wars_";
    }
  }

  int _getImageIndex(List<int> usedImages) {
    var random = Random();
    int imageIndex = random.nextInt(14) + 1;

    if (!usedImages.contains(imageIndex)) {
      return imageIndex;
    }

    int i = imageIndex + 1;
    while (i <= 15) {
      if (!usedImages.contains(i)) {
        return i;
      }

      i++;
    }

    i = 1;
    while (i < imageIndex) {
      if (!usedImages.contains(i)) {
        return i;
      }

      i++;
    }

    throw ArgumentError();
  }

  void _fillBoardCell(int index, String imagePath) {
    if (_fillHigherBoardCell(index, imagePath)) {
      return;
    }

    if (_fillLowerBoardCell(index, imagePath)) {
      return;
    }

    throw ArgumentError();
  }

  bool _fillHigherBoardCell(int index, String imagePath) {
    int target = 0;
    for (int row = 0; row < rowCount; row++) {
      for (int column = 0; column < columnCount; column++) {
        if (target >= index && _board[row][column] == null) {
          _board[row][column] = CardInfo(imagePath: imagePath, found: false);
          return true;
        }
        target++;
      }
    }

    return false;
  }

  bool _fillLowerBoardCell(int index, String imagePath) {
    int target = 0;
    for (int row = rowCount - 1; row >= 0; row--) {
      for (int column = columnCount - 1; column >= 0; column--) {
        if (target <= index && _board[row][column] == null) {
          _board[row][column] = CardInfo(imagePath: imagePath, found: false);
          return true;
        }
        target++;
      }
    }

    return false;
  }

  void _initCountdown() {
    remainingTime = totalTime;
    _countdown = Timer.periodic(const Duration(seconds: 1), (_) async {
      remainingTime = Duration(seconds: remainingTime.inSeconds - 1);
      if (remainingTime.inSeconds == 0) {
        await _finishGame(false);
      }
    });
  }

  Future<void> _finishGame(bool gameWon) async {
    _countdown.cancel();
    await _navigationService.navigateToGameOverPopup(gameWon);

    _attempsNumber = 0;
    _cardPairsFound = 0;
    _currentCardController = null;
    _isShowingCard = false;
    _currentCard = null;
    _createBoard();
    _initCountdown();
  }

  Animation<double> _getAppearingAnimation(double step, int index) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animationController, curve: Interval(step * index, 0.5 + step * index, curve: Curves.linear)));
  }

  @override
  void dispose() {
    super.dispose();
    _countdown.cancel();
    animationController.dispose();
  }
}
